-- SpellFly
-- This addon animates spell icons so they fly off the screen whenever the
-- player successfully casts a spell.  The effect is purely visual and does
-- not interfere with normal spell functionality.

local SpellFly = CreateFrame("Frame")

-- Cache often used globals locally for slight performance gains and
-- to avoid accidental taint when other addons modify them.
local pairs       = pairs
local math_random     = math.random
local math_randomseed = math.randomseed
local math_abs        = math.abs
local math_atan2      = math.atan2
local math_cos        = math.cos
local math_sin        = math.sin

-- Provide a fallback implementation for math.atan2 for older game builds
-- where it may not be available. This ensures the minimap button drag logic
-- works reliably across versions.
if not math_atan2 then
  function math_atan2(y, x)
    if x > 0 then
      return math.atan(y / x)
    elseif x < 0 and y >= 0 then
      return math.atan(y / x) + math.pi
    elseif x < 0 and y < 0 then
      return math.atan(y / x) - math.pi
    elseif x == 0 and y > 0 then
      return math.pi / 2
    elseif x == 0 and y < 0 then
      return -math.pi / 2
    end
    return 0
  end
  math.atan2 = math_atan2
end
local tinsert         = table.insert
local tremove         = table.remove
local wipe            = wipe

local UIParent          = UIParent
local GetCursorPosition = GetCursorPosition
local GetSpellTexture   = GetSpellTexture
local GetSpellInfo      = GetSpellInfo

-- Initialise saved variables with sensible defaults on first load. This table
-- persists between sessions and is declared in the TOC via SavedVariables.
SpellFlyDB = SpellFlyDB or {
  -- When true the spell icon also flies from the action button used
  offActionBar = true,
  -- When true the spell icon additionally flies from the screen centre
  fromCenter = false,
  -- Angle around the minimap for the addon button
  minimapAngle = 0,
}

-- Forward declaration for the options frame so helper functions can access it.
local optionsFrame

-- UNIT_SPELLCAST_SUCCEEDED gives us reliable information about spells cast by
-- the player without needing to parse the combat log.
SpellFly:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
SpellFly:RegisterEvent("PLAYER_LOGIN")
SpellFly:RegisterEvent("ACTIONBAR_SLOT_CHANGED")

-- Frame pool used to recycle icon frames for better performance and to avoid
-- creating excessive UI widgets on repeated casts.
local iconPool = {}

-- Map of action slot -> action button for quick lookup
local slotButtonMap = {}

local lastOriginInfo -- table with pre-calculated x, y, w, h

-- Forward declare for use in CaptureButtonInfo.
local GetOriginInfo

-- Utility that attempts to find an action button frame for a given action slot.
-- This relies on the default UI's ActionBarButtonEventsFrame which keeps a list
-- of all action buttons.
local function GetButtonForAction(slot)
  if not slot then
    return nil
  end

  -- Use cached lookup when available for better performance.
  local button = slotButtonMap[slot]
  if button then
    return button
  end

  -- Build the cache if it hasn't been created yet or if this slot was not found.
  if ActionBarButtonEventsFrame and ActionBarButtonEventsFrame.frames then
    wipe(slotButtonMap)
    for _, b in pairs(ActionBarButtonEventsFrame.frames) do
      if b and b.action then
        slotButtonMap[b.action] = b
        if b.action == slot then
          button = b
        end
      end
    end
  end

  return button
end

-- Hook UseAction so we know which button (if any) the player activated.  This
-- allows the animation to originate from the correct on-screen location.
local function CaptureButtonInfo(button)
  if button then
    local x, y, w, h = GetOriginInfo(button)
    if x then
      lastOriginInfo = {x = x, y = y, w = w, h = h}
    else
      lastOriginInfo = nil
    end
  else
    lastOriginInfo = nil
  end
end

if UseAction and hooksecurefunc then
  hooksecurefunc("UseAction", function(slot)
    CaptureButtonInfo(GetButtonForAction(slot))
  end)
end

-- Hook action buttons directly so we capture the exact frame the user clicked.
local function HookActionButtons()
  if not ActionBarButtonEventsFrame or not ActionBarButtonEventsFrame.frames then
    return
  end

  -- Refresh the slot->button mapping each time we hook.
  wipe(slotButtonMap)

  for _, button in pairs(ActionBarButtonEventsFrame.frames) do
    if button then
      if button.action then
        slotButtonMap[button.action] = button
      end
      if not button.SpellFlyHooked then
        button:HookScript("OnMouseDown", function(self)
          CaptureButtonInfo(self)
        end)
        button.SpellFlyHooked = true
      end
    end
  end
end

-- Acquire a frame from the pool or create a new one when needed.
  local function AcquireIconFrame()
    local frame = tremove(iconPool)
    if not frame then
      frame = CreateFrame("Frame", nil, UIParent)
      frame:SetSize(50, 50)
      frame:EnableMouse(false)

      frame.texture = frame:CreateTexture(nil, "OVERLAY")
      frame.texture:SetAllPoints(frame)
    else
      frame:SetParent(UIParent)
      -- Reset size in case a previous animation used custom dimensions
      frame:SetSize(50, 50)
      frame.texture:SetTexture(nil)
    end

    frame:SetFrameStrata("HIGH")

  frame:ClearAllPoints()
  -- Ensure the frame starts fully transparent for the fade in
  frame:SetAlpha(0)
  frame:Show()
  frame.animationGroup = nil

  return frame
end

-- Release a frame back into the pool once its animation finishes.
local function ReleaseIconFrame(frame)
  if frame.animationGroup then
    frame.animationGroup:SetScript("OnFinished", nil)
    frame.animationGroup:Stop()
  end

  frame:Hide()
  frame:SetAlpha(0)
  frame.texture:SetTexture(nil)
  frame:SetParent(nil)
  frame.animationGroup = nil
  tinsert(iconPool, frame)
end

-- Implementation assigned after forward declaration above.
GetOriginInfo = function(origin)
  if type(origin) == "table" then
    return origin.x, origin.y, origin.w, origin.h
  end

  if not origin or not origin.IsVisible or not origin:IsVisible() then
    return nil
  end

  local icon = origin.icon or origin.Icon or origin.IconTexture or origin.iconTexture
  if icon and icon:IsVisible() then
    local x, y = icon:GetCenter()
    local w, h = icon:GetSize()
    if x and y then
      return x, y, w, h
    end
  end

  local x, y = origin:GetCenter()
  local w, h = origin:GetSize()
  if x and y then
    return x, y, w, h
  end

  return nil
end

-- Create and play the flying animation for the provided spellID.
-- If `origin` is a valid frame the animation begins from that frame's centre.
-- When `origin` is nil or not visible it will start from the screen centre.
local function PlaySpellAnimation(spellID, origin)
  -- Get the icon for this spell.  Some spells may not have a texture, in which
  -- case we simply abort the animation.
  -- Blizzard removed the global GetSpellTexture API in later versions.  Use the
  -- C_Spell version if available, or fall back to GetSpellInfo which also
  -- returns the spell icon.
  local texture
  if GetSpellTexture then
    texture = GetSpellTexture(spellID)
  elseif C_Spell and C_Spell.GetSpellTexture then
    texture = C_Spell.GetSpellTexture(spellID)
  else
    local _, _, icon = GetSpellInfo(spellID)
    texture = icon
  end
  if not texture then
    return
  end

  local iconFrame = AcquireIconFrame()
  iconFrame.texture:SetTexture(texture)

  -- Determine the starting point and match the size of the button's icon when possible.
  local startX, startY, w, h = GetOriginInfo(origin)
  if not startX then
    startX, startY = UIParent:GetCenter()
  end
  if w and h and w > 0 and h > 0 then
    iconFrame:SetSize(w, h)
  end
  -- Use a sensible default when no size information is available.
  if not (w and h and w > 0 and h > 0) then
    iconFrame:SetSize(50, 50)
  end
  iconFrame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", startX, startY)

  local animationGroup = iconFrame:CreateAnimationGroup()
  iconFrame.animationGroup = animationGroup

  local fadeIn = animationGroup:CreateAnimation("Alpha")
  fadeIn:SetFromAlpha(0)
  fadeIn:SetToAlpha(1)
  fadeIn:SetDuration(0.2)

  local move = animationGroup:CreateAnimation("Translation")
  local screenWidth = UIParent:GetWidth()
  local distanceToLeft = startX
  local distanceToRight = screenWidth - startX
  local diff = math_abs(distanceToRight - distanceToLeft)
  local direction
  if diff <= 5 then
    -- When near the middle of the screen pick a random direction
    direction = math_random(0, 1) == 0 and -1 or 1
  else
    -- Otherwise prefer the shortest path off screen
    direction = distanceToRight < distanceToLeft and 1 or -1
  end
  local horizontalOffset
  if direction == 1 then
    horizontalOffset = distanceToRight + iconFrame:GetWidth()
  else
    horizontalOffset = -(distanceToLeft + iconFrame:GetWidth())
  end
  move:SetOffset(horizontalOffset, math_random(-100, 100))
  move:SetDuration(2)
  move:SetSmoothing("OUT")

  local fadeOut = animationGroup:CreateAnimation("Alpha")
  fadeOut:SetFromAlpha(1)
  fadeOut:SetToAlpha(0)
  fadeOut:SetStartDelay(1.5)
  fadeOut:SetDuration(0.5)

  animationGroup:SetScript("OnFinished", function()
    ReleaseIconFrame(iconFrame)
  end)

  animationGroup:Play()
end

-- Event handler for UNIT_SPELLCAST_SUCCEEDED. We only care about the player.
SpellFly:SetScript("OnEvent", function(_, event, ...)
  if event == "PLAYER_LOGIN" then
    HookActionButtons()
    if UpdateMinimapButtonPosition then
      UpdateMinimapButtonPosition()
    end
    return
  elseif event == "ACTIONBAR_SLOT_CHANGED" then
    -- Re-hook buttons to account for newly created ones or changes.
    HookActionButtons()
    return
  end

  local unit, _, spellID = ...
  if unit ~= "player" or not spellID then
    return
  end

  -- Determine whether any origins are enabled. If none are checked we skip
  -- playing animations entirely.
  local doBar = SpellFlyDB.offActionBar and lastOriginInfo
  local doCenter = SpellFlyDB.fromCenter
  if not doBar and not doCenter then
    lastOriginInfo = nil
    return
  end

  if doBar then
    PlaySpellAnimation(spellID, lastOriginInfo)
  end
  if doCenter then
    PlaySpellAnimation(spellID, nil)
  end

  lastOriginInfo = nil
end)

-- Seed the random generator using a time-based value to avoid identical
-- patterns across sessions. `time()` is available in all WoW Lua
-- environments and provides a reasonably unpredictable seed.
if math and math_randomseed and time then
  math_randomseed(time())
end

-- ---------------------------------------------------------------------
-- Options UI and minimap button
-- ---------------------------------------------------------------------

-- Helper to show or hide the options frame. If the frame hasn't been created
-- yet it will be initialised here.
function SpellFly:ToggleOptions()
  if not optionsFrame then
    -- Basic frame container using the game's standard template for consistency
    optionsFrame = CreateFrame("Frame", "SpellFlyOptionsFrame", UIParent, "BasicFrameTemplateWithInset")
    optionsFrame:SetSize(260, 120)
    optionsFrame:SetPoint("CENTER")
    optionsFrame:SetMovable(true)
    optionsFrame:EnableMouse(true)
    optionsFrame:SetClampedToScreen(true)
    optionsFrame:RegisterForDrag("LeftButton")
    optionsFrame:SetScript("OnDragStart", optionsFrame.StartMoving)
    optionsFrame:SetScript("OnDragStop", optionsFrame.StopMovingOrSizing)

    optionsFrame.title = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    optionsFrame.title:SetPoint("CENTER", optionsFrame.TitleBg, "CENTER", 0, 0)
    optionsFrame.title:SetText("SpellFly Options")

    -- Allow the frame to be dismissed with the ESC key
    tinsert(UISpecialFrames, optionsFrame:GetName())

    -- Overlay to close the options when clicking outside
    optionsFrame.backdrop = CreateFrame("Button", nil, UIParent)
    optionsFrame.backdrop:SetAllPoints(UIParent)
    -- Match the options frame strata so the backdrop always sits behind it
    optionsFrame.backdrop:SetFrameStrata(optionsFrame:GetFrameStrata())
    -- Ensure the backdrop is one level lower so clicks on the options frame are not intercepted
    optionsFrame.backdrop:SetFrameLevel(math.max(0, optionsFrame:GetFrameLevel() - 1))
    -- Explicitly enable mouse so the click is registered even if some addons manipulate it
    optionsFrame.backdrop:EnableMouse(true)
    optionsFrame.backdrop:Hide()
    optionsFrame.backdrop:SetScript("OnClick", function()
      optionsFrame:Hide()
    end)
    optionsFrame:HookScript("OnHide", function()
      optionsFrame.backdrop:Hide()
    end)

    -- Checkbox: enable animations from the action bar
    local check1 = CreateFrame("CheckButton", nil, optionsFrame, "ChatConfigCheckButtonTemplate")
    check1:SetPoint("TOPLEFT", 20, -40)
    check1.Text:SetText("Fly from Action Bar")
    check1:SetChecked(SpellFlyDB.offActionBar)
    check1:SetScript("OnClick", function(self)
      SpellFlyDB.offActionBar = self:GetChecked()
    end)

    -- Checkbox: enable animations from the screen centre
    local check2 = CreateFrame("CheckButton", nil, optionsFrame, "ChatConfigCheckButtonTemplate")
    check2:SetPoint("TOPLEFT", check1, "BOTTOMLEFT", 0, -10)
    check2.Text:SetText("Fly from Screen Centre")
    check2:SetChecked(SpellFlyDB.fromCenter)
    check2:SetScript("OnClick", function(self)
      SpellFlyDB.fromCenter = self:GetChecked()
    end)

    optionsFrame:Hide()
  end

  if optionsFrame:IsShown() then
    optionsFrame:Hide()
  else
    optionsFrame:Show()
    if optionsFrame.backdrop then
      optionsFrame.backdrop:Show()
    end
  end
end

-- Create a simple minimap button that opens the options when clicked.
local minimapButton = CreateFrame("Button", "SpellFlyMinimapButton", Minimap)
minimapButton:SetSize(32, 32)
minimapButton:SetFrameStrata("MEDIUM")

local function UpdateMinimapButtonPosition()
  local angle = SpellFlyDB.minimapAngle or 0
  local radius = Minimap:GetWidth() / 2 + 10
  local x = math_cos(angle) * radius
  local y = math_sin(angle) * radius
  minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

UpdateMinimapButtonPosition()

minimapButton.icon = minimapButton:CreateTexture(nil, "ARTWORK")
minimapButton.icon:SetAllPoints()
minimapButton.icon:SetTexture("Interface\\AddOns\\SpellFly\\magifly.png")

minimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
minimapButton:RegisterForDrag("LeftButton")
minimapButton:SetScript("OnDragStart", function(self)
  self:SetScript("OnUpdate", function()
    local mx, my = GetCursorPosition()
    local px, py = Minimap:GetCenter()
    local scale = Minimap:GetEffectiveScale()
    if mx and my and px and py and scale then
      mx, my = mx / scale, my / scale
      SpellFlyDB.minimapAngle = math_atan2(my - py, mx - px)
      UpdateMinimapButtonPosition()
    end
  end)
end)
minimapButton:SetScript("OnDragStop", function(self)
  self:SetScript("OnUpdate", nil)
  UpdateMinimapButtonPosition()
end)
minimapButton:SetScript("OnClick", function()
  SpellFly:ToggleOptions()
end)
minimapButton:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
  GameTooltip:SetText("SpellFly Options")
  GameTooltip:Show()
end)
minimapButton:SetScript("OnLeave", function()
  GameTooltip:Hide()
end)

-- Slash command to open the options panel.
SLASH_SPELLFLY1 = "/fly"
SlashCmdList["SPELLFLY"] = function()
  SpellFly:ToggleOptions()
end

