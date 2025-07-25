-- EnchantBuddy: Disenchant items sequentially with a single key.
-- This addon creates a hidden secure button bound to a user configurable key.
-- Pressing the key will disenchant the next suitable item in your bags.

local addonName, addon = ...

-- Saved variables table
EnchantBuddyDB = EnchantBuddyDB or {}

-- Frame used for events
local eventFrame = CreateFrame("Frame")

-- Reference to our secure button created in XML
local button = EnchantBuddyButton

-- Helper to apply the key binding using override bindings
local function ApplyBinding(key)
  ClearOverrideBindings(button)
  if key and key ~= "" then
    SetOverrideBindingClick(button, true, key, button:GetName(), "LeftButton")
  end
end

-- PreClick handler called from the secure button before each click
function EnchantBuddy_PreClick(self)
  -- Do nothing if we are still casting Disenchant
  if UnitCastingInfo("player") or UnitChannelInfo("player") then
    return
  end

  -- Scan bags 0-4 for the next green quality or better item
  for bag = 0, 4 do
    local slotCount = C_Container.GetContainerNumSlots(bag)
    for slot = 1, slotCount do
      local info = C_Container.GetContainerItemInfo(bag, slot)
      if info and info.quality and info.quality >= 2 then
        -- Set macrotext to pick up this slot and cast Disenchant
        local macro = string.format(
          "/run C_Container.PickupContainerItem(%d, %d)\n/cast Disenchant",
          bag, slot
        )
        self:SetAttribute("macrotext", macro)
        return
      end
    end
  end

  -- No more items to disenchant
  self:SetAttribute("macrotext", "/run print('EnchantBuddy: no disenchantable items.')")
end

-- Options panel elements
local optionsPanel
local setKeyButton
local captureFrame = CreateFrame("Frame")

-- Function to create the options panel
local function CreateOptions()
  optionsPanel = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
  optionsPanel.name = "EnchantBuddy"

  local title = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 16, -16)
  title:SetText("EnchantBuddy")

  local keyLabel = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  keyLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)

  setKeyButton = CreateFrame("Button", nil, optionsPanel, "UIPanelButtonTemplate")
  setKeyButton:SetSize(180, 22)
  setKeyButton:SetPoint("TOPLEFT", keyLabel, "BOTTOMLEFT", 0, -10)
  setKeyButton:SetText("Set Disenchant Key")

  setKeyButton:SetScript("OnClick", function(self)
    self:SetText("Press a key...")
    captureFrame:Show()
    captureFrame:SetPropagateKeyboardInput(false)
    captureFrame:EnableKeyboard(true)
    captureFrame:SetFrameStrata("DIALOG")
    print("EnchantBuddy: press any key to bind.")
  end)

  optionsPanel.refresh = function()
    keyLabel:SetText("Current key: " .. (EnchantBuddyDB.key or ""))
    setKeyButton:SetText("Set Disenchant Key")
  end

  InterfaceOptions_AddCategory(optionsPanel)
end

-- Capture frame used to listen for the next key press
captureFrame:Hide()

captureFrame:SetScript("OnKeyDown", function(_, key)
  captureFrame:Hide()
  captureFrame:EnableKeyboard(false)
  EnchantBuddyDB.key = key
  ApplyBinding(key)
  if optionsPanel and optionsPanel.refresh then
    optionsPanel.refresh()
  end
  print("EnchantBuddy: bound to key " .. key)
end)

-- Slash command to open the options panel
SLASH_ENCHANTBUDDY1 = "/enchantbuddy"
SlashCmdList.ENCHANTBUDDY = function()
  InterfaceOptionsFrame_OpenToCategory(optionsPanel)
  InterfaceOptionsFrame_OpenToCategory(optionsPanel) -- called twice per Blizzard bug
end

-- Event handler
eventFrame:SetScript("OnEvent", function(_, event, arg1)
  if event == "ADDON_LOADED" and arg1 == addonName then
    -- Initialize saved variable and apply default key if none
    if not EnchantBuddyDB.key then
      EnchantBuddyDB.key = "0" -- default key
    end
    ApplyBinding(EnchantBuddyDB.key)
    CreateOptions()
    eventFrame:UnregisterEvent("ADDON_LOADED")
  end
end)

eventFrame:RegisterEvent("ADDON_LOADED")
