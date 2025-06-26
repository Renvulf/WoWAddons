-- SpellFly
-- This addon animates spell icons so they fly off the screen whenever the
-- player successfully casts a spell.  The effect is purely visual and does
-- not interfere with normal spell functionality.

local SpellFly = CreateFrame("Frame")

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

  for button in pairs(ActionBarButtonEventsFrame.frames) do
    if button.action == slot then
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
-- Create and play the flying animation for the provided spellID.  If
-- `origin` is supplied and is a valid frame, the animation will begin from its
-- on-screen location; otherwise it starts from the center of the screen.
local function PlaySpellAnimation(spellID, origin)
  -- Get the icon for this spell.  Some spells may not have a texture, in which
  -- case we simply abort the animation.
  local texture = GetSpellTexture(spellID)
  if not texture then
    return
  end

  local iconFrame = AcquireIconFrame()
  iconFrame.texture:SetTexture(texture)

  -- Position the icon frame.  Default to the centre of the screen if we cannot
  -- determine a specific origin frame.
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
  if unit ~= "player" then
    return
  end

  if spellID then
    PlaySpellAnimation(spellID, lastUsedButton)
    lastUsedButton = nil
  end
end)

-- Random seed for the move offset so different sessions don't start with the
-- same pattern.  os.time() is sufficient for this simple visual effect.
-- Seed the pseudo random generator if the Lua math library supports it.
if math and math.randomseed then
  math.randomseed(GetTime() * 1000)
end

