--[[
MarioDeathSound
Plays the Super Mario death sound when the player's character dies.
]]

-- Constants
local SOUND_PATH = "Interface\\AddOns\\MarioDeathSound\\queue.ogg" -- Path to sound file
local SOUND_CHANNEL = "Master" -- Audio channel to play the sound on

-- Create a frame to listen for events. Using a local frame keeps the global
-- namespace clean.
local frame = CreateFrame("Frame")

-- Register for the PLAYER_DEAD event which fires when the player's character dies.
frame:RegisterEvent("PLAYER_DEAD")

-- Event handler function. It is assigned to all registered events on the frame.
-- For future expansion, the 'event' parameter can be checked if multiple events
-- are registered on the same frame.
local function OnEvent(self, event, ...)
    -- Attempt to play the sound file. Wrapping in pcall guards against any
    -- unexpected errors (for example if the sound file is missing).
    local ok, handle = pcall(PlaySoundFile, SOUND_PATH, SOUND_CHANNEL)
    if not ok then
        -- If playing the sound failed, print a warning to the default chat frame.
        DEFAULT_CHAT_FRAME:AddMessage("[MarioDeathSound] Failed to play sound: " .. tostring(handle))
    end
end

-- Attach the handler to the frame's OnEvent script.
frame:SetScript("OnEvent", OnEvent)
