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

-- Forward declaration for the options frame so helper functions can access it.
local optionsFrame

-- UNIT_SPELLCAST_SUCCEEDED gives us reliable information about spells cast by
-- the player without needing to parse the combat log.
SpellFly:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

-- Frame pool used to recycle icon frames for better performance and to avoid
-- creating excessive UI widgets on repeated casts.
local iconPool = {}

-- Store the last action button that triggered a spell cast so we can start
-- the animation from its location.  This will be updated whenever the player
-- uses an action button via clicking or keybinds.
local lastUsedButton

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

-- Hook UseAction so we know which button (if any) the player activated.  This
-- allows the animation to originate from the correct on-screen location.
if UseAction then
  hooksecurefunc("UseAction", function(slot)
    lastUsedButton = GetButtonForAction(slot)
  end)
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
  -- otherwise fall back to the centre of the screen.
  local startX, startY
  if origin and origin:IsVisible() then
    startX, startY = origin:GetCenter()
  end
  if not startX then
    startX, startY = UIParent:GetCenter()
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
  local direction = distanceToRight < distanceToLeft and 1 or -1
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
  local doBar = SpellFlyDB.offActionBar and lastUsedButton and lastUsedButton:IsVisible()
  local doCenter = SpellFlyDB.fromCenter
  if not doBar and not doCenter then
    lastUsedButton = nil
    return
  end

  if doBar then
    PlaySpellAnimation(spellID, lastUsedButton)
  end
  if doCenter then
    PlaySpellAnimation(spellID, nil)
  end

  lastUsedButton = nil
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
  end
end

-- Create a simple minimap button that opens the options when clicked.
local minimapButton = CreateFrame("Button", "SpellFlyMinimapButton", Minimap)
minimapButton:SetSize(32, 32)
minimapButton:SetFrameStrata("MEDIUM")
minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT")

minimapButton.icon = minimapButton:CreateTexture(nil, "ARTWORK")
minimapButton.icon:SetAllPoints()
minimapButton.icon:SetTexture("Interface\\AddOns\\SpellFly\\magifly.png")

minimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
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

