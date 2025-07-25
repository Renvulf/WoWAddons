local addonName, addon = ...
local DISENCHANT_SPELL_ID = 13262
EnchantBuddyDB = EnchantBuddyDB or {}

-- track scan position
addon.nextBag, addon.nextSlot = 0, 1

-- forward-declared for ADDON_LOADED
local button

-- only player bags 0–4
local TOTAL_BAGS = 5

-- Apply override-binding to our secure button
local function ApplyBinding(key)
  if not button then return end
  ClearOverrideBindings(button)
  if type(key) == "string" and key ~= "" then
    SetOverrideBindingClick(button, true, key, button:GetName(), "LeftButton")
  end
end

-- runs inside the secure context, before each click
function EnchantBuddy_PreClick(self)
  if UnitCastingInfo("player") or UnitChannelInfo("player") then return end
  if not IsSpellKnown(DISENCHANT_SPELL_ID, true) then
    print("EnchantBuddy: Disenchant spell not known.")
    return
  end
  if CursorHasItem() then
    print("EnchantBuddy: clear your cursor before pressing the key.")
    return
  end

  -- scan bags 0–4 only
  for i = 0, TOTAL_BAGS - 1 do
    local bag = (addon.nextBag + i) % TOTAL_BAGS
    local slotCount = C_Container.GetContainerNumSlots(bag)
    local startSlot = (bag == addon.nextBag) and addon.nextSlot or 1

    for slot = startSlot, slotCount do
      local info = C_Container.GetContainerItemInfo(bag, slot)
      if info and not info.isLocked and info.quality >= 2 then
        addon.nextBag = bag
        addon.nextSlot = slot + 1
        if addon.nextSlot > slotCount then
          addon.nextBag = (addon.nextBag + 1) % TOTAL_BAGS
          addon.nextSlot = 1
        end

        local macro = string.format(
          "/run ClearCursor(); C_Container.PickupContainerItem(%d, %d)\n/cast Disenchant",
          bag, slot
        )
        self:SetAttribute("macrotext1", macro)
        return
      end
    end
  end

  -- nothing left → reset and notify
  addon.nextBag, addon.nextSlot = 0, 1
  self:SetAttribute("macrotext1", "/run print('EnchantBuddy: no disenchantable items.')")
end

-- options UI
local optionsPanel, setKeyButton, captureFrame = nil, nil, CreateFrame("Frame")

local function CreateOptions()

  optionsPanel = CreateFrame("Frame", "EnchantBuddyOptions", InterfaceOptionsFramePanelContainer)
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
    self:SetText("Press a key…")
    captureFrame:Show()
    captureFrame:EnableKeyboard(true)
    print("EnchantBuddy: press any key to bind.")
  end)

  local clearKeyButton = CreateFrame("Button", nil, optionsPanel, "UIPanelButtonTemplate")
  clearKeyButton:SetSize(180, 22)
  clearKeyButton:SetPoint("TOPLEFT", setKeyButton, "BOTTOMLEFT", 0, -5)
  clearKeyButton:SetText("Clear Binding")
  clearKeyButton:SetScript("OnClick", function()
    EnchantBuddyDB.key = ""
    ApplyBinding("")
    optionsPanel.refresh()
    print("EnchantBuddy: binding cleared")
  end)

  optionsPanel.refresh = function()
    keyLabel:SetText("Current key: " .. (EnchantBuddyDB.key or "none"))
    setKeyButton:SetText("Set Disenchant Key")
  end
  optionsPanel.refresh()

  -- now safe to add to Blizzard’s Interface Options
  InterfaceOptions_AddCategory(optionsPanel)
end

-- listen for keypress after clicking “Set Disenchant Key”
captureFrame:Hide()
captureFrame:SetPropagateKeyboardInput(false)
captureFrame:SetScript("OnKeyDown", function(_, key)
  captureFrame:Hide()
  captureFrame:EnableKeyboard(false)
  key = (type(key)=="string" and key ~= "") and key:lower() or ""
  if key ~= "" then
    EnchantBuddyDB.key = key
    ApplyBinding(key)
    optionsPanel.refresh()
    print("EnchantBuddy: bound to key " .. key)
  else
    print("EnchantBuddy: invalid key")
  end
end)

-- slash to open options
SLASH_ENCHANTBUDDY1 = "/enchantbuddy"
SlashCmdList.ENCHANTBUDDY = function()
  InterfaceOptionsFrame_OpenToCategory(optionsPanel)
  InterfaceOptionsFrame_OpenToCategory(optionsPanel)  -- Blizzard bug workaround
end

-- event handling
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(self, event, arg1)
  if event == "ADDON_LOADED" and arg1 == addonName then
    -- only once
    self:UnregisterEvent("ADDON_LOADED")

    -- create the secure button used for disenchanting
    button = CreateFrame("Button", "EnchantBuddyButton", UIParent, "SecureActionButtonTemplate")
    button:SetSize(1, 1)
    button:SetAttribute("PreClick", EnchantBuddy_PreClick)
    button:SetAttribute("type1", "macro")
    button:SetAttribute("macrotext1", "/run -- placeholder")
    button:Hide()

    -- init saved-vars
    if type(EnchantBuddyDB) ~= "table" then EnchantBuddyDB = {} end
    if type(EnchantBuddyDB.key) ~= "string" then EnchantBuddyDB.key = "" end
    if EnchantBuddyDB.key == "" then EnchantBuddyDB.key = "0" end

    ApplyBinding(EnchantBuddyDB.key)

  elseif event == "PLAYER_LOGIN" then
    self:UnregisterEvent("PLAYER_LOGIN")
    CreateOptions()
    if not IsSpellKnown(DISENCHANT_SPELL_ID, true) then
      print("EnchantBuddy: Disenchant not known; button inactive until learned.")
    end
  end
end)
