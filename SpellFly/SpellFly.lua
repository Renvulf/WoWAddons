-- SpellFly
-- This addon animates spell icons so they fly off the screen whenever the
-- player successfully casts a spell.  The effect is purely visual and does
-- not interfere with normal spell functionality.

local SpellFly = CreateFrame("Frame")

-- Initialise saved variables with sensible defaults on first load.  The
-- database table persists between sessions and is declared in the TOC via the
-- `SavedVariables` directive.
SpellFlyDB = SpellFlyDB or {}
-- Allow the spell icon to fly from the action bar by default.  If the variable
-- already exists we honour the user's setting.
if SpellFlyDB.offActionBar == nil then
  SpellFlyDB.offActionBar = true
end
-- Disable flying from the centre of the screen by default so new installations
-- start with only the action bar behaviour.  Users may opt in via the options
-- panel and the choice will persist across sessions.
if SpellFlyDB.fromCenter == nil then
  SpellFlyDB.fromCenter = false
end
-- Default placement for the minimap button roughly at the top-left edge.
if SpellFlyDB.minimapAngle == nil then
  SpellFlyDB.minimapAngle = 135
end

-- Forward declaration for the options frame so helper functions can access it.
-- Forward declare frames so nested functions can reference them even before
-- they are instantiated later in the file.
local optionsFrame
local minimapButton

-- UNIT_SPELLCAST_SUCCEEDED gives us reliable information about spells cast by
-- the player without needing to parse the combat log.
-- Register for UNIT_SPELLCAST_SUCCEEDED when any origin is enabled.  This is
-- adjusted dynamically as the user toggles options so no unnecessary work is
-- done when all animations are disabled.
local function UpdateEventRegistration()
  if SpellFlyDB.offActionBar or SpellFlyDB.fromCenter then
    SpellFly:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
  else
    SpellFly:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
  end
end

UpdateEventRegistration()

-- Frame pool used to recycle icon frames for better performance and to avoid
-- creating excessive UI widgets on repeated casts.
local iconPool = {}


-- Helper that converts a frame's centre coordinates into UIParent space while
-- taking scale differences into account. Returns nil if the frame has no
-- centre, which can happen if it hasn't been laid out yet.
local function GetUIParentRelativeCenter(frame)
  if not frame or not frame.GetCenter then
    return nil
  end

  local x, y = frame:GetCenter()
  if not x then
    return nil
  end

  local scale = frame:GetEffectiveScale()
  local uiScale = UIParent:GetEffectiveScale()
  if not scale or scale == 0 or not uiScale or uiScale == 0 then
    return nil
  end

  return x * scale / uiScale, y * scale / uiScale
end

-- Utility that attempts to find an action button frame for a given action slot.
-- This relies on the default UI's ActionBarButtonEventsFrame which keeps a list
-- of all action buttons.
local function GetButtonForAction(slot)
  if not slot or not ActionBarButtonEventsFrame or not ActionBarButtonEventsFrame.frames then
    return nil
  end

  -- ActionBarButtonEventsFrame.frames is a list of action button frames.  When
  -- iterating with pairs the table keys are numeric indices, so we must use the
  -- value rather than the key.  Otherwise we would end up with the index number
  -- and attempt to access "button.action" on a number which causes errors.
  for _, button in pairs(ActionBarButtonEventsFrame.frames) do
    if button and button.action == slot then
      return button
    end
  end

  return nil
end


--[[
Finding the action button that triggered a spell cast can be accomplished via
the C_ActionBar API in modern clients.  This avoids hooking secure functions
like UseAction which may lead to taint.  If the API isn't available we fall
back to scanning all action slots.  Only visible buttons are returned so the
animation starts from an on-screen location when possible.
]]
local function FindVisibleButtonForSpell(spellID)
  if not spellID then
    return nil
  end

  -- Retail clients provide C_ActionBar.FindSpellActionButtons for an efficient
  -- lookup.  Iterate through any returned slots and pick the first visible
  -- button.
  if C_ActionBar and C_ActionBar.FindSpellActionButtons then
    local slots = C_ActionBar.FindSpellActionButtons(spellID)
    if slots then
      for _, slot in ipairs(slots) do
        local button = GetButtonForAction(slot)
        if button and button:IsVisible() then
          return button
        end
      end
    end
  else
    -- Fallback for older clients: manually inspect each action slot.
    local maxSlots = ACTION_BUTTON_COUNT or 120
    for slot = 1, maxSlots do
      local actionType, id = GetActionInfo(slot)
      if actionType == "spell" and id == spellID then
        local button = GetButtonForAction(slot)
        if button and button:IsVisible() then
          return button
        end
      end
    end
  end

  return nil
end

-- Acquire a frame from the pool or create a new one when needed.
local function AcquireIconFrame()
  local frame = table.remove(iconPool)
  if not frame then
    frame = CreateFrame("Frame", nil, UIParent)
    frame:SetSize(50, 50)
    frame:SetFrameStrata("HIGH")

    frame.texture = frame:CreateTexture(nil, "OVERLAY")
    frame.texture:SetAllPoints(frame)
  end

  frame:ClearAllPoints()
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
  frame.texture:SetTexture(nil)
  table.insert(iconPool, frame)
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

  -- Determine the starting point.  If a valid frame was supplied start there,
  -- otherwise fall back to the centre of the screen.  Coordinates are converted
  -- to the UIParent scale so the animation originates precisely over the
  -- action button even when different scales are used.
  local startX, startY
  if origin and origin:IsVisible() then
    startX, startY = GetUIParentRelativeCenter(origin)
    -- Match the flying icon size to the action button when possible.
    if startX then
      local w, h = origin:GetSize()
      if w and h and w > 0 and h > 0 then
        iconFrame:SetSize(w, h)
      end
    end
  end
  if not startX then
    -- Fallback to the centre of the screen when no valid origin was supplied.
    startX, startY = GetUIParentRelativeCenter(UIParent)
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

  -- If the animation started from the screen centre randomise the
  -- horizontal direction so icons can fly either left or right.  For
  -- action bar origins continue to move towards the nearest edge.
  local direction
  if origin == nil or not origin:IsVisible() then
    direction = math.random(0, 1) == 1 and 1 or -1
  else
    direction = distanceToRight < distanceToLeft and 1 or -1
  end

  local horizontalOffset
  if direction == 1 then
    horizontalOffset = distanceToRight + iconFrame:GetWidth()
  else
    horizontalOffset = -(distanceToLeft + iconFrame:GetWidth())
  end

  move:SetOffset(horizontalOffset, math.random(-100, 100))
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
SpellFly:SetScript("OnEvent", function(_, _, unit, _, spellID)
  if unit ~= "player" or not spellID then
    return
  end

  -- Determine whether any origins are enabled. If none are checked we skip
  -- playing animations entirely.
  local actionButton
  if SpellFlyDB.offActionBar then
    actionButton = FindVisibleButtonForSpell(spellID)
  end

  local doBar = actionButton ~= nil
  local doCenter = SpellFlyDB.fromCenter

  if not doBar and not doCenter then
    return
  end

  if doBar then
    PlaySpellAnimation(spellID, actionButton)
  end
  if doCenter then
    PlaySpellAnimation(spellID, nil)
  end
end)

-- Random seed for the move offset so different sessions don't start with the
-- same pattern.  os.time() is sufficient for this simple visual effect.
-- Seed the pseudo random generator if the Lua math library supports it.
if math and math.randomseed then
  math.randomseed(GetTime() * 1000)
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
    optionsFrame:RegisterForDrag("LeftButton")
    optionsFrame:SetScript("OnDragStart", optionsFrame.StartMoving)
    optionsFrame:SetScript("OnDragStop", optionsFrame.StopMovingOrSizing)

    optionsFrame.title = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    optionsFrame.title:SetPoint("CENTER", optionsFrame.TitleBg, "CENTER", 0, 0)
    optionsFrame.title:SetText("SpellFly Options")

    -- Checkbox: enable animations from the action bar
    local check1 = CreateFrame("CheckButton", nil, optionsFrame, "ChatConfigCheckButtonTemplate")
    check1:SetPoint("TOPLEFT", 20, -40)
    check1.Text:SetText("Fly from Action Bar")
    check1:SetChecked(SpellFlyDB.offActionBar)
    check1:SetScript("OnClick", function(self)
      SpellFlyDB.offActionBar = self:GetChecked()
      UpdateEventRegistration()
    end)

    -- Checkbox: enable animations from the screen centre
    local check2 = CreateFrame("CheckButton", nil, optionsFrame, "ChatConfigCheckButtonTemplate")
    check2:SetPoint("TOPLEFT", check1, "BOTTOMLEFT", 0, -10)
    check2.Text:SetText("Fly from Screen Centre")
    check2:SetChecked(SpellFlyDB.fromCenter)
    check2:SetScript("OnClick", function(self)
      SpellFlyDB.fromCenter = self:GetChecked()
      UpdateEventRegistration()
    end)

    -- Allow the frame to be closed with the Escape key like other special windows
    -- by adding it to the global UISpecialFrames list once it has a name.
    local name = optionsFrame:GetName()
    if name and UISpecialFrames and not tContains(UISpecialFrames, name) then
      table.insert(UISpecialFrames, name)
    end

    optionsFrame:Hide()
  end

  if optionsFrame:IsShown() then
    optionsFrame:Hide()
  else
    optionsFrame:Show()
  end
end

-- ---------------------------------------------------------------------
-- Minimap button helpers
-- ---------------------------------------------------------------------

-- Update the minimap button position around the minimap's edge based on
-- the stored angle in the saved variables.
local function UpdateMinimapButtonPosition()
  -- Radius is calculated from the minimap size so behaviour stays consistent
  -- when using different minimap shapes or scales.
  local radius = (Minimap:GetWidth() / 2) + 5
  local angle = SpellFlyDB.minimapAngle or 0
  local x = math.cos(math.rad(angle)) * radius
  local y = math.sin(math.rad(angle)) * radius
  minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

-- While dragging, continuously update the saved angle to match the cursor.
local function MinimapButton_OnUpdate(self)
  local mx, my = Minimap:GetCenter()
  local px, py = GetCursorPosition()
  local scale = Minimap:GetEffectiveScale()
  if not (mx and my and px and py and scale) then
    return
  end
  local dx, dy = px / scale - mx, py / scale - my
  local angle = math.deg(math.atan2(dy, dx))
  if angle < 0 then
    angle = angle + 360
  end
  SpellFlyDB.minimapAngle = angle
  UpdateMinimapButtonPosition()
end

-- Create a simple minimap button that opens the options when clicked.
-- The minimap button is declared above so functions can reference it even
-- before this line executes.  Here we assign it without another `local`
-- declaration so the existing upvalue receives the frame object.
minimapButton = CreateFrame("Button", "SpellFlyMinimapButton", Minimap)
minimapButton:SetSize(32, 32)
minimapButton:SetFrameStrata("MEDIUM")
minimapButton:SetMovable(true)
minimapButton:RegisterForDrag("LeftButton")
minimapButton:SetScript("OnDragStart", function(self)
  self:SetScript("OnUpdate", MinimapButton_OnUpdate)
end)
minimapButton:SetScript("OnDragStop", function(self)
  self:SetScript("OnUpdate", nil)
  MinimapButton_OnUpdate(self)
end)

minimapButton.icon = minimapButton:CreateTexture(nil, "ARTWORK")
minimapButton.icon:SetAllPoints()
minimapButton.icon:SetTexture("Interface\\AddOns\\SpellFly\\magifly.png")

minimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
-- Position the button using the stored angle on initial load.
UpdateMinimapButtonPosition()
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

