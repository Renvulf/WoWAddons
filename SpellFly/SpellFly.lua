local frame = CreateFrame("FRAME")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local iconTexture, spellID, cooldownStartTime

local function CreateIconCopy()
  local iconCopy = CreateFrame("Frame", nil, UIParent)
  iconCopy:SetSize(50, 50)
  iconCopy:SetPoint("CENTER", UIParent, "CENTER")
  iconCopy:SetFrameStrata("HIGH")

  local icon = iconCopy:CreateTexture(nil, "OVERLAY")
  icon:SetAllPoints(iconCopy)
  icon:SetTexture(iconTexture)

  local animationGroup = iconCopy:CreateAnimationGroup()
  local fadeIn = animationGroup:CreateAnimation("Alpha")
  fadeIn:SetFromAlpha(0)
  fadeIn:SetToAlpha(1)
  fadeIn:SetDuration(0.5)

  local move = animationGroup:CreateAnimation("Translation")
  local direction = math.random(0, 1) == 0 and -1 or 1
  local xDistance = math.random(200, 800)
  local yDistance = math.random(-100, 100)
  move:SetOffset(xDistance * direction, yDistance)
  move:SetDuration(2)
  move:SetSmoothing("OUT")

  local fadeOut = animationGroup:CreateAnimation("Alpha")
  fadeOut:SetFromAlpha(1)
  fadeOut:SetToAlpha(0)
  fadeOut:SetStartDelay(1.5)
  fadeOut:SetDuration(0.5)

  animationGroup:SetScript("OnFinished", function() iconCopy:Hide() end)
  animationGroup:Play()
end

frame:SetScript("OnEvent", function(self, event, ...)
  local timestamp, eventType, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellID, spellName = CombatLogGetCurrentEventInfo()

  if eventType == "SPELL_CAST_SUCCESS" and sourceName == UnitName("player") and spellID == spellID then
    local start, duration, enable = GetSpellCooldown(spellID)
    cooldownStartTime = GetTime() - start
    iconTexture = GetSpellTexture(spellID)
    CreateIconCopy()
  end
end)
