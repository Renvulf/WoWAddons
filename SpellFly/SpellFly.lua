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
-- Forward declarations
local GetOriginInfo
local CaptureButtonInfo
local AddButtonToMap

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
SpellFly:RegisterEvent("PLAYER_ENTERING_WORLD")
SpellFly:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
SpellFly:RegisterEvent("ACTIONBAR_PAGE_CHANGED")

-- Frame pool used to recycle icon frames for better performance and to avoid
-- creating excessive UI widgets on repeated casts.
local iconPool = {}

-- Map of action slot -> action button for quick lookup
-- Cached lookup of action slot -> action button.
-- This improves performance when mapping slots to frames during casts.
local slotButtonMap = {}

-- Patterns for common action button names used across the default UI.
-- These act as a fallback when ActionBarButtonEventsFrame does not list a
-- particular button (which can occur in some UI states).
local fallbackButtonPatterns = {
  "ActionButton%d",                 -- Main bar
  "MultiBarBottomLeftButton%d",    -- Bottom left bar
  "MultiBarBottomRightButton%d",   -- Bottom right bar
  "MultiBarRightButton%d",         -- Right bar
  "MultiBarLeftButton%d",          -- Left bar
  "MultiBar5Button%d",             -- Extra bars introduced in later patches
  "MultiBar6Button%d",
  "MultiBar7Button%d",
  "MultiBar8Button%d",
  "PetActionButton%d",
  "ShapeshiftButton%d",
  "OverrideActionBarButton%d",
}


-- Helper used by HookActionButtons to register a button frame. This keeps
-- the slot cache in sync and ensures we only hook each button once.
local function AddButtonToMap(button)
  if not button or not button.action then
    return
  end

  slotButtonMap[button.action] = button

  if not button.SpellFlyHooked then
    button:HookScript("OnMouseDown", function(self)
      CaptureButtonInfo(self)
    end)
    button.SpellFlyHooked = true
  end
end
-- Utility to scan all UI frames for action buttons. This helps support
-- third-party action bar addons which may not register their buttons with the
-- default ActionBarButtonEventsFrame.
local function EnumerateUnknownActionButtons()
  if not EnumerateFrames then
    return
  end

  local frame = EnumerateFrames()
  while frame do
    if frame.action and frame.GetName and frame:IsObjectType("CheckButton") then
      AddButtonToMap(frame)
    end
    frame = EnumerateFrames(frame)
  end
end

local lastOriginInfo -- table with pre-calculated x, y, w, h
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

  -- Build the cache when not found. This covers both the standard list and the
  -- fallback patterns so we only pay the enumeration cost once when a mapping
  -- is missing.
  wipe(slotButtonMap)

  if ActionBarButtonEventsFrame and ActionBarButtonEventsFrame.frames then
    for _, b in pairs(ActionBarButtonEventsFrame.frames) do
      AddButtonToMap(b)
      if not button and b and b.action == slot then
        button = b
      end
    end
  end

  if not button then
    for i = 1, 12 do
      for _, pattern in ipairs(fallbackButtonPatterns) do
        local btn = _G[pattern:format(i)]
        AddButtonToMap(btn)
        if not button and btn and btn.action == slot then
          button = btn
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

if hooksecurefunc then
  hooksecurefunc("CastSpellByName", function(spellName)
    CaptureButtonInfo(nil)
  end)
  -- SpellBook buttons do not use a global click handler, so we hook them
  -- individually later instead of using hooksecurefunc here.
  -- hooksecurefunc("SpellButton_OnClick", function(self)
  --   CaptureButtonInfo(self)
  -- end)
end

-- Hook action buttons directly so we capture the exact frame the user clicked.
-- Collect action buttons from various sources and hook them for capture.
local function HookActionButtons()
  wipe(slotButtonMap)

  -- ActionBarButtonEventsFrame maintains a list of active action buttons.
  if ActionBarButtonEventsFrame and ActionBarButtonEventsFrame.frames then
    for _, button in pairs(ActionBarButtonEventsFrame.frames) do
      AddButtonToMap(button)
    end
  end

  -- Fallback enumeration of known button name patterns for UI elements that
  -- may not be included in ActionBarButtonEventsFrame.frames.
  for i = 1, 12 do
    for _, pattern in ipairs(fallbackButtonPatterns) do
      local btn = _G[pattern:format(i)]
      AddButtonToMap(btn)
    end
  end

  -- Additional scan for buttons created by other addons. This call is
  -- relatively heavy so we restrict it to situations where buttons have
  -- potentially changed (PLAYER_LOGIN or ACTIONBAR_SLOT_CHANGED).
  EnumerateUnknownActionButtons()
end

-- Hook all visible SpellBook spell buttons so we can capture their location
-- when the player clicks them. We hook via SpellBookFrame_UpdateSpellButtons
-- because the buttons are dynamically wired by Blizzard and do not share a
-- global click handler.
local function HookSpellBookButtons()
  if SpellFly.SpellBookHooked then return end
  SpellFly.SpellBookHooked = true

  local MAX_BUTTONS = SPELLS_PER_PAGE or 12
  hooksecurefunc("SpellBookFrame_UpdateSpellButtons", function()
    for i = 1, MAX_BUTTONS do
      local btn = _G["SpellButton"..i]
      if btn and not btn.__SpellFlyHooked then
        btn:HookScript("OnClick", function(self)
          CaptureButtonInfo(self)
        end)
        btn.__SpellFlyHooked = true
      end
    end
  end)
end

-- Acquire a frame from the pool or create a new one when needed.
local function AcquireIconFrame()
  local frame = tremove(iconPool)
  if frame then
    if frame.animationGroup then
      frame.animationGroup:SetScript("OnFinished", nil)
      frame.animationGroup:Stop()
      frame.animationGroup = nil
    end
  else
    frame = CreateFrame("Frame", nil, UIParent)
    frame.texture = frame:CreateTexture(nil, "OVERLAY")
    frame.texture:SetAllPoints(frame)
  end
  frame:SetParent(UIParent)
  frame:SetFrameStrata("HIGH")
  frame:SetSize(50, 50)
  frame.texture:SetTexture(nil)
  frame:ClearAllPoints()
  frame:SetAlpha(0)
  frame:Show()
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
  -- 1) Table-based origin (saved coords)
  if type(origin) == "table" and origin.x and origin.y then
    return origin.x, origin.y, origin.w, origin.h
  end
  -- 2) Frame must be visible
  if not origin or not origin.IsVisible or not origin:IsVisible() then
    return nil
  end
  -- 3) Try common icon fields & APIs
  local icon = origin.icon
            or origin.Icon
            or origin.IconTexture
            or (origin.GetNormalTexture and origin:GetNormalTexture())
  if icon and icon:IsVisible() then
    local x,y = icon:GetCenter()
    local w,h = icon:GetSize()
    if x and y then return x, y, w, h end
  end
  -- 4) Scan Regions for a texture fallback
  for _, region in ipairs({ origin:GetRegions() }) do
    if region:GetObjectType() == "Texture" and region:GetTexture() then
      local x,y = region:GetCenter()
      local w,h = region:GetSize()
      if x and y then return x, y, w, h end
    end
  end
  -- 5) Last-ditch: origin’s center
  local x,y = origin:GetCenter()
  local w,h = origin:GetSize()
  if x and y then return x, y, w, h end
  return nil
end
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

-- Main event handler. Sets up button hooks and plays animations for the
-- player's successful spell casts.
SpellFly:SetScript("OnEvent", function(_, event, ...)
  if event == "PLAYER_LOGIN" then
    math_randomseed(time())
    HookActionButtons()
    HookSpellBookButtons()
    if UpdateMinimapButtonPosition then
      UpdateMinimapButtonPosition()
    end
    return
  elseif event == "PLAYER_ENTERING_WORLD" then
    HookActionButtons()
    HookSpellBookButtons()
    if UpdateMinimapButtonPosition then
      UpdateMinimapButtonPosition()
    end
    return
  elseif event == "ACTIONBAR_SLOT_CHANGED" then
    HookActionButtons()
    return
  elseif event == "ACTIONBAR_PAGE_CHANGED" then
    HookActionButtons()
    return
  end
  local unit, _, spellID = ...
  if unit ~= "player" or not spellID then
    return
  end

  -- Grab and clear any stored action-bar origin so we never reuse stale data.
  local origin = lastOriginInfo
  lastOriginInfo = nil

  -- Show from action bar only if requested and a valid origin was captured.
  if SpellFlyDB.offActionBar and origin then
    PlaySpellAnimation(spellID, origin)
  end

  -- Show from the screen centre when explicitly enabled by the user.
  if SpellFlyDB.fromCenter then
    PlaySpellAnimation(spellID, nil)
  end
end)

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

