local addonName, addon = ...
local DISENCHANT_SPELL_ID = 13262
-- populated in PLAYER_LOGIN when the client is fully loaded
local DISENCHANT_SPELL_NAME
EnchantBuddyDB = EnchantBuddyDB or {}

-- localize frequently used globals for performance
local C_Container = C_Container
local _GetNumSlots = C_Container.GetContainerNumSlots
local _GetInfo = C_Container.GetContainerItemInfo
local _UnitCasting = UnitCastingInfo
local _UnitChannel = UnitChannelInfo
local _CursorHasItem = CursorHasItem
local _IsSpellKnown = IsSpellKnown
local C_Item = C_Item
local _GetMacroIndex = GetMacroIndexByName
local _CreateMacro = CreateMacro
local _EditMacro = EditMacro
local _GetMacroInfo = GetMacroInfo
local _GetNumMacros = GetNumMacros

-- localize spell API
local C_Spell = C_Spell
local _GetSpellInfo = C_Spell.GetSpellInfo
local _GetSpellTexture = C_Spell.GetSpellTexture



-- track scan position
-- indices correspond to entries in BAG_IDS
addon.nextBag, addon.nextSlot = 1, 1

-- forward-declared for ADDON_LOADED
local button

-- Build the list of bag IDs that represent the player's inventory bags.
-- Only these bags are scanned for disenchantable items.
local function BuildBagList()
  local bags = {BACKPACK_CONTAINER}
  for i = 1, (NUM_BAG_SLOTS or 4) do
    bags[#bags + 1] = i
  end
  if Enum and Enum.BagIndex and Enum.BagIndex.ReagentBag then
    bags[#bags + 1] = Enum.BagIndex.ReagentBag
  elseif type(REAGENTBAG_CONTAINER) == "number" then
    bags[#bags + 1] = REAGENTBAG_CONTAINER
  end
  return bags
end
local BAG_IDS = BuildBagList()
local TOTAL_BAGS = #BAG_IDS

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
  local texture = _GetSpellTexture(DISENCHANT_SPELL_ID) or "INV_MISC_QUESTIONMARK"
  if index == 0 then
    -- determine which macro tab has space
    local generalCount, charCount = _GetNumMacros()
    if generalCount < MAX_ACCOUNT_MACROS then
      index = _CreateMacro(MACRO_NAME, texture, MACRO_BODY, false)
    elseif charCount < MAX_CHARACTER_MACROS then
      index = _CreateMacro(MACRO_NAME, texture, MACRO_BODY, true)
    else
      UIErrorsFrame:AddMessage("EnchantBuddy: cannot create macro \226\128\148 slots full.", 1, 0.2, 0.2)
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
  if _UnitCasting("player") or _UnitChannel("player") then
    self:SetAttribute("macrotext1", "/run print('EnchantBuddy: casting in progress.')")
    return
  end
  if not _IsSpellKnown(DISENCHANT_SPELL_ID, true) then
    self:SetAttribute("macrotext1", "/run print('EnchantBuddy: Disenchant spell not known.')")
    return
  end
  if _CursorHasItem() then
    self:SetAttribute("macrotext1", "/run print('EnchantBuddy: clear your cursor before pressing the key.')")
    return
  end

  -- scan player bags sequentially
  for i = 0, TOTAL_BAGS - 1 do
    local bagIndex = ((addon.nextBag - 1 + i) % TOTAL_BAGS) + 1
    local bag = BAG_IDS[bagIndex]
    local slotCount = _GetNumSlots(bag)
    local startSlot = (bagIndex == addon.nextBag) and addon.nextSlot or 1

    for slot = startSlot, slotCount do
      local info = _GetInfo(bag, slot)
      local itemID = info and info.itemID
      if info and not info.isLocked and itemID and C_Item.IsItemDisenchantableBySpell(itemID, DISENCHANT_SPELL_ID) then
        addon.nextBag = bagIndex
        -- keep scanning the same slot on the next pass because the bag
        -- compresses after an item is removed. This avoids skipping items
        -- that shift into the current slot.
        addon.nextSlot = slot
        -- move to the next bag once we reach the final slot
        if addon.nextSlot >= slotCount then
          addon.nextBag = (addon.nextBag % TOTAL_BAGS) + 1
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
  addon.nextBag, addon.nextSlot = 1, 1
  self:SetAttribute("macrotext1", "/run print('EnchantBuddy: no disenchantable items.')")
end

-- a simple, standalone options window
local customOptions
local captureFrame = CreateFrame("Frame")

local function CreateCustomOptions()
  if customOptions then return end
  -- Use the BackdropTemplate mixin instead of DialogBorderedFrameTemplate
  -- which does not exist in Retail. We manually apply a backdrop and
  -- border so the options panel remains visually similar.
  local f = CreateFrame("Frame", "EnchantBuddyCustomOptions", UIParent, "BackdropTemplate")
  f:SetBackdrop({
    bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile     = true, tileSize = 32, edgeSize = 16,
    insets   = { left = 8, right = 8, top = 8, bottom = 8 },
  })
  f:SetBackdropBorderColor(0.4, 0.4, 0.4)
  -- allow the user to resize if content grows
  f:SetResizable(true)
  -- Use whichever API is available. Retail removed SetMinResize/SetMaxResize
  -- in favor of SetResizeBounds. Guard the calls to avoid errors on older
  -- versions or forks.
  if f.SetResizeBounds then
    -- SetResizeBounds(minWidth, minHeight, maxWidth, maxHeight)
    f:SetResizeBounds(300, 160, 600, 400)
  else
    if f.SetMinResize then f:SetMinResize(300, 160) end
    if f.SetMaxResize then f:SetMaxResize(600, 400) end
  end
  -- default size is slightly wider/taller to fit everything
  f:SetSize(320, 180) -- wider/taller to fit everything
  f:SetPoint("CENTER")
  f:SetMovable(true); f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", f.StartMoving)
  f:SetScript("OnDragStop", f.StopMovingOrSizing)

  -- add a scroll area so extra controls won't get cut off
  local scroll = CreateFrame("ScrollFrame", "EnchantBuddyOptionsScroll", f, "UIPanelScrollFrameTemplate")
  scroll:SetPoint("TOPLEFT", 10, -30)
  scroll:SetPoint("BOTTOMRIGHT", -28, 10)
  local content = CreateFrame("Frame", "EnchantBuddyOptionsContent", scroll)
  content:SetSize(1, 1) -- will auto-expand
  scroll:SetScrollChild(content)

  local title = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOP", 0, -10)
  title:SetText("EnchantBuddy Settings")

  local keyLabel = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  keyLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)
  keyLabel:SetText("Current key: " .. (EnchantBuddyDB.key or "none"))

  local setKey = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
  setKey:SetSize(160, 22)
  setKey:SetPoint("TOPLEFT", keyLabel, "BOTTOMLEFT", 0, -8)
  setKey:SetText("Set Disenchant Key")
  setKey:SetScript("OnClick", function(self)
    self:SetText("Press any key…")
    captureFrame:Show(); captureFrame:EnableKeyboard(true)
    print("EnchantBuddy: press any key to bind.")
  end)

  local clearKey = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
  clearKey:SetSize(160, 22)
  clearKey:SetPoint("LEFT", setKey, "RIGHT", 8, 0)
  clearKey:SetText("Clear Binding")
  clearKey:SetScript("OnClick", function()
    EnchantBuddyDB.key = ""
    ApplyBinding("")
    keyLabel:SetText("Current key: none")
    print("EnchantBuddy: binding cleared")
  end)

  f.refresh = function()
    keyLabel:SetText("Current key: " .. (EnchantBuddyDB.key or "none"))
    setKey:SetText("Set Disenchant Key")
  end

  customOptions = f
end

-- listen for keypress after clicking “Set Disenchant Key”
captureFrame:Hide()
captureFrame:SetPropagateKeyboardInput(false)
-- Capture a key press for binding. ESC cancels without changing the current key.
captureFrame:SetScript("OnKeyDown", function(_, key)
  captureFrame:Hide()
  captureFrame:EnableKeyboard(false)
  key = (type(key) == "string" and key ~= "") and key or ""

  if key == "ESCAPE" then
    -- treat escape as a cancel action
    if customOptions and customOptions.refresh then customOptions:refresh() end
    print("EnchantBuddy: key binding canceled")
    return
  end

  if key ~= "" then
    EnchantBuddyDB.key = key
    ApplyBinding(key)
    if customOptions and customOptions.refresh then customOptions:refresh() end
    print("EnchantBuddy: bound to key " .. key)
  else
    print("EnchantBuddy: invalid key")
  end
end)

-- slash to open options
SLASH_ENCHANTBUDDY1 = "/enchantbuddy"
SlashCmdList.ENCHANTBUDDY = function()
  CreateCustomOptions()
  customOptions:Show()
  customOptions:refresh()
  EnsureMacro()
end

-- event handling
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("SPELLS_CHANGED")
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

    ApplyBinding(EnchantBuddyDB.key)

  elseif event == "PLAYER_LOGIN" then
    self:UnregisterEvent("PLAYER_LOGIN")
    -- now safe to query spell information
    DISENCHANT_SPELL_NAME = _GetSpellInfo(DISENCHANT_SPELL_ID) or "Disenchant"
    CreateCustomOptions()
    EnsureMacro()
    if not _IsSpellKnown(DISENCHANT_SPELL_ID, true) then
      print("EnchantBuddy: Disenchant not known; button inactive until learned.")
    end
    -- ── Minimap Button ────────────────────────────────────────────────
    if not _G.EnchantBuddyMinimapButton then
      local mb = CreateFrame("Button", "EnchantBuddyMinimapButton", Minimap, "BackdropTemplate")
      mb:SetSize(26, 26)
      mb:SetFrameLevel(Minimap:GetFrameLevel() + 2)
      mb:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
      })
      mb.icon = mb:CreateTexture(nil, "ARTWORK")
      mb.icon:SetAllPoints()
      mb.icon:SetTexture("Interface\\Icons\\INV_Scroll_02")
      EnchantBuddyDB.minimapPos = EnchantBuddyDB.minimapPos or 45
      local angle = math.rad(EnchantBuddyDB.minimapPos)
      local radius = 80
      mb:SetPoint("CENTER", Minimap, "CENTER", radius * math.cos(angle), radius * math.sin(angle))
      mb:SetMovable(true)
      mb:SetClampedToScreen(true)
      mb:RegisterForDrag("LeftButton")
      mb:SetScript("OnDragStart", function(self) self:StartMoving() end)
      mb:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local x, y = self:GetCenter()
        local mX, mY = Minimap:GetCenter()
        local dx, dy = x - mX, y - mY
        local angle = math.atan2(dy, dx)
        EnchantBuddyDB.minimapPos = math.deg(angle)
        local radius = 80
        self:ClearAllPoints()
        self:SetPoint("CENTER", Minimap, "CENTER", radius * math.cos(angle), radius * math.sin(angle))
      end)
      mb:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("EnchantBuddy")
        GameTooltip:Show()
      end)
      mb:SetScript("OnLeave", GameTooltip_Hide)
      mb:SetScript("OnClick", function()
        if customOptions and customOptions:IsShown() then
          customOptions:Hide()
        else
          customOptions:Show()
          customOptions:refresh()
        end
      end)
    end

  elseif event == "SPELLS_CHANGED" then
    if _IsSpellKnown(DISENCHANT_SPELL_ID, true) then
      DISENCHANT_SPELL_NAME = _GetSpellInfo(DISENCHANT_SPELL_ID)
      EnsureMacro() -- recreate/update with correct spell name
    end
  end
end)
