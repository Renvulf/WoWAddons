local frame = CreateFrame("FRAME", "MyAddon");
local SOUND_PATH = "Interface\\AddOns\\MarioDeathSound\\queue.ogg";
local SOUND_CHANNEL = "Master";
frame:RegisterEvent("PLAYER_DEAD");
local function eventHandler(self, event, ...)
 PlaySoundFile(SOUND_PATH, SOUND_CHANNEL);
end
frame:SetScript("OnEvent", eventHandler);