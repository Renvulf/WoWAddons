local addonName, addon = ...
local DISENCHANT_SPELL_ID = 13262
local DISENCHANT_SPELL_NAME = GetSpellInfo(DISENCHANT_SPELL_ID) or "Disenchant"
EnchantBuddyDB = EnchantBuddyDB or {}

-- localize frequently used globals for performance
local C_Container = C_Container
local _GetNumSlots = C_Container.GetContainerNumSlots
local _GetInfo = C_Container.GetContainerItemInfo
local _Pickup = C_Container.PickupContainerItem
local _UnitCasting = UnitCastingInfo
local _UnitChannel = UnitChannelInfo
local _CursorHasItem = CursorHasItem
local _IsSpellKnown = IsSpellKnown
local _ClearCursor = ClearCursor
local C_Item = C_Item
local _GetMacroIndex = GetMacroIndexByName
local _CreateMacro = CreateMacro
local _EditMacro = EditMacro
local _GetMacroInfo = GetMacroInfo
local _GetNumMacros = GetNumMacros
local _GetSpellTexture = GetSpellTexture

-- ensure the Blizzard options UI is available without external dependencies
local function EnsureOptionsLoaded()
  if not InterfaceOptionsFrame or not InterfaceOptions_AddCategory or not InterfaceOptionsFrame_OpenToCategory then
    -- load the built-in options addon if it isn't already
    pcall(UIParentLoadAddOn, "Blizzard_Options")
  end
end

-- track scan position
addon.nextBag, addon.nextSlot = 0, 1

-- forward-declared for ADDON_LOADED
local button

-- player bag containers: backpack (0) plus equipped bags
local TOTAL_BAGS = (NUM_BAG_SLOTS or 4) + 1

-- Apply override-binding to our secure button
local function ApplyBinding(key)
  if not button then return end
  ClearOverrideBindings(button)
  if type(key) == "string" and key ~= "" then
    SetOverrideBindingClick(button, true, key, button:GetName(), "LeftButton")
  end
end

-- Create or update the macro that triggers our secure button
local MACRO_NAME = "EnchantBuddy"
local MACRO_BODY = "/click EnchantBuddyButton"
local function EnsureMacro()
  local index = _GetMacroIndex(MACRO_NAME)
  local texture = GetSpellTexture(DISENCHANT_SPELL_ID) or "INV_MISC_QUESTIONMARK"
  if index == 0 then
    -- determine which macro tab has space
    local generalCount, charCount = _GetNumMacros()
    if generalCount < MAX_ACCOUNT_MACROS then
      index = _CreateMacro(MACRO_NAME, texture, MACRO_BODY, false)
    elseif charCount < MAX_CHARACTER_MACROS then
      index = _CreateMacro(MACRO_NAME, texture, MACRO_BODY, true)
    else
      print("EnchantBuddy: cannot create macro—macro slots full.")
      return
    end
    if index then
      print("EnchantBuddy: macro created. Drag it to your action bar.")
    end
  else
    local _, _, body = _GetMacroInfo(index)
    if body ~= MACRO_BODY then
      _EditMacro(index, MACRO_NAME, texture, MACRO_BODY)
    end
  end
end

-- runs inside the secure context, before each click
function EnchantBuddy_PreClick(self)
  if _UnitCasting("player") or _UnitChannel("player") then return end
  if not _IsSpellKnown(DISENCHANT_SPELL_ID, true) then
    print("EnchantBuddy: Disenchant spell not known.")
    return
  end
  if _CursorHasItem() then
    print("EnchantBuddy: clear your cursor before pressing the key.")
    return
  end

  -- scan player bags sequentially
  for i = 0, TOTAL_BAGS - 1 do
    local bag = (addon.nextBag + i) % TOTAL_BAGS
    local slotCount = _GetNumSlots(bag)
    local startSlot = (bag == addon.nextBag) and addon.nextSlot or 1

    for slot = startSlot, slotCount do
      local info = _GetInfo(bag, slot)
      local itemID = info and info.itemID
      if info and not info.isLocked and itemID and C_Item.IsItemDisenchantableBySpell(itemID, DISENCHANT_SPELL_ID) then
        addon.nextBag = bag
        -- keep scanning the same slot on the next pass because the bag
        -- compresses after an item is removed. This avoids skipping items
        -- that shift into the current slot.
        addon.nextSlot = slot
        -- move to the next bag once we reach the final slot
        if addon.nextSlot >= slotCount then
          addon.nextBag = (addon.nextBag + 1) % TOTAL_BAGS
          addon.nextSlot = 1
        end

        local macro = string.format(
          "/run ClearCursor(); C_Container.PickupContainerItem(%d, %d)\n/cast %s",
          bag, slot, DISENCHANT_SPELL_NAME
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
  -- ensure the Blizzard options UI addon is loaded so the panel APIs exist
  EnsureOptionsLoaded()

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

  -- now safe to add to Blizzard’s Interface Options (if available)
  if InterfaceOptions_AddCategory then
    InterfaceOptions_AddCategory(optionsPanel)
  else
    print("EnchantBuddy: Blizzard interface options API not available.")
  end
end

-- listen for keypress after clicking “Set Disenchant Key”
captureFrame:Hide()
captureFrame:SetPropagateKeyboardInput(false)
captureFrame:SetScript("OnKeyDown", function(_, key)
  captureFrame:Hide()
  captureFrame:EnableKeyboard(false)
  key = (type(key)=="string" and key ~= "") and key or ""
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
  EnsureOptionsLoaded()
  if InterfaceOptionsFrame_OpenToCategory then
    InterfaceOptionsFrame_OpenToCategory(optionsPanel)
    InterfaceOptionsFrame_OpenToCategory(optionsPanel)  -- Blizzard bug workaround
  else
    print("EnchantBuddy: cannot open options—InterfaceOptionsFrame API missing.")
  end
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
    EnsureMacro()
    if not _IsSpellKnown(DISENCHANT_SPELL_ID, true) then
      print("EnchantBuddy: Disenchant not known; button inactive until learned.")
    end
  end
end)
