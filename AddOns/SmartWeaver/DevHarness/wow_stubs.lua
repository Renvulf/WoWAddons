-- minimal WoW API stubs for offline tests
C_Item = { }
function C_Item.GetItemStats(link) return link.stats or {} end
C_Container = {}
function C_Container.GetContainerItemLink() return nil end
function GetDetailedItemLevelInfo() return 0 end
function GetInventoryItemLink() return nil end
function UnitName() return 'Tester', true end
function GetRealmName() return 'Test' end
function GetSpecialization() return 1 end
function GetSpecializationInfo() return 62 end
function GetSpecializationRole() return 'DAMAGER' end
function time() return os.time() end
