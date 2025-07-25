-- EnchantBuddy: Disenchant items sequentially with a single key.
-- This addon creates a hidden secure button bound to a user configurable key.
-- Pressing the key will disenchant the next suitable item in your bags.

local addonName, addon = ...

-- Track the next bag and slot to start searching from. This helps avoid
-- scanning the entire inventory every click.
addon.nextBag = 0
addon.nextSlot = 1

-- Spell ID for Disenchant to easily check if the player knows the ability
local DISENCHANT_SPELL_ID = 13262

-- Saved variables table
EnchantBuddyDB = EnchantBuddyDB or {}

-- Frame used for events
local eventFrame = CreateFrame("Frame")

-- Reference to our secure button created in XML.  This will be assigned
-- once the XML is loaded during ADDON_LOADED.
local button

-- Total number of bags (0-11 includes bank bags)
local TOTAL_BAGS = 12

-- Helper to apply the key binding using override bindings
local function ApplyBinding(key)
  -- button may not exist until ADDON_LOADED fires
  if not button then return end
  ClearOverrideBindings(button)
  if type(key) == "string" and key ~= "" then
    SetOverrideBindingClick(button, true, key, button:GetName(), "LeftButton")
  end
end

-- PreClick handler called from the secure button before each click
function EnchantBuddy_PreClick(self)
  -- Do nothing if we are still casting Disenchant
  if UnitCastingInfo("player") or UnitChannelInfo("player") then
    return
  end

  -- Ensure the player can actually disenchant items
  if not IsSpellKnown(DISENCHANT_SPELL_ID, true) then
    print("EnchantBuddy: Disenchant spell not known.")
    return
  end

  -- Don't accidentally overwrite an item already held on the cursor
  if CursorHasItem() then
    print("EnchantBuddy: clear your cursor before pressing the key.")
    return
  end

  -- Scan the player's bags (and bank when open) for the next valid target.
  -- We resume from the last bag/slot found so repeatedly pressing the key
  -- moves sequentially through your inventory without restarting from the first
  -- bag every time.
  for i = 0, TOTAL_BAGS - 1 do
    local bag = (addon.nextBag + i) % TOTAL_BAGS
    local slotCount = C_Container.GetContainerNumSlots(bag)
    local startSlot = 1
    if bag == addon.nextBag then
      startSlot = addon.nextSlot
    end

    for slot = startSlot, slotCount do
      local info = C_Container.GetContainerItemInfo(bag, slot)
      if info and not info.isLocked and info.quality and info.quality >= 2 then
        -- Advance the stored position for the next search
        addon.nextBag = bag
        addon.nextSlot = slot + 1
        if addon.nextSlot > slotCount then
          addon.nextBag = (addon.nextBag + 1) % TOTAL_BAGS
          addon.nextSlot = 1
        end

        -- Pick up the item and cast Disenchant
        local macro = string.format(
          "/run ClearCursor(); C_Container.PickupContainerItem(%d, %d)\n/cast Disenchant",
          bag, slot
        )
        self:SetAttribute("macrotext", macro)
        return
      end
    end

    addon.nextBag = (addon.nextBag + 1) % TOTAL_BAGS
    addon.nextSlot = 1
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

  -- Button to clear the current binding
  local clearKeyButton = CreateFrame("Button", nil, optionsPanel, "UIPanelButtonTemplate")
  clearKeyButton:SetSize(180, 22)
  clearKeyButton:SetPoint("TOPLEFT", setKeyButton, "BOTTOMLEFT", 0, -5)
  clearKeyButton:SetText("Clear Binding")
  clearKeyButton:SetScript("OnClick", function()
    EnchantBuddyDB.key = ""
    ApplyBinding("")
    if optionsPanel and optionsPanel.refresh then
      optionsPanel.refresh()
    end
    print("EnchantBuddy: binding cleared")
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
  if type(key) == "string" and key ~= "" then
    EnchantBuddyDB.key = key
    ApplyBinding(key)
    if optionsPanel and optionsPanel.refresh then
      optionsPanel.refresh()
    end
    print("EnchantBuddy: bound to key " .. key)
  else
    print("EnchantBuddy: invalid key")
  end
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
    -- XML is loaded at this point so grab the secure button reference
    button = EnchantBuddyButton

    -- Initialize saved variable and apply default key if none
    if type(EnchantBuddyDB.key) ~= "string" or EnchantBuddyDB.key == "" then
      EnchantBuddyDB.key = "0" -- default key
    end

    ApplyBinding(EnchantBuddyDB.key)
    CreateOptions()

    if not IsSpellKnown(DISENCHANT_SPELL_ID, true) then
      print("EnchantBuddy: Disenchant spell not known. The button will be inactive until you learn it.")
    end
    eventFrame:UnregisterEvent("ADDON_LOADED")
  end
end)

eventFrame:RegisterEvent("ADDON_LOADED")
