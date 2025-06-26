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
  frame:SetPoint("CENTER", UIParent, "CENTER")
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
local function PlaySpellAnimation(spellID)
  -- Get the icon for this spell.  Some spells may not have a texture, in which
  -- case we simply abort the animation.
  local texture = GetSpellTexture(spellID)
  if not texture then
    return
  end

  local iconFrame = AcquireIconFrame()
  iconFrame.texture:SetTexture(texture)

  local animationGroup = iconFrame:CreateAnimationGroup()
  iconFrame.animationGroup = animationGroup

  local fadeIn = animationGroup:CreateAnimation("Alpha")
  fadeIn:SetFromAlpha(0)
  fadeIn:SetToAlpha(1)
  fadeIn:SetDuration(0.2)

  local move = animationGroup:CreateAnimation("Translation")
  local direction = math.random(0, 1) == 0 and -1 or 1
  move:SetOffset(math.random(200, 800) * direction, math.random(-100, 100))
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
    PlaySpellAnimation(spellID)
  end
end)

-- Random seed for the move offset so different sessions don't start with the
-- same pattern.  os.time() is sufficient for this simple visual effect.
math.randomseed(GetTime() * 1000)

