local addonName, Smartbot = ...
Smartbot = Smartbot or {}
-- Data derived from ZygorGuidesViewer/Data-Retail/Item-Statweights.lua (MIT License)
Smartbot.ClassSpecRules = {
  ['DEATHKNIGHT'] = {
    [1] = { itemtypes={ TH_POLE=true, TH_AXE=true, TH_MACE=true, TH_SWORD=true, PLATE=true }, primary='STRENGTH' },
    [2] = { itemtypes={ AXE=true, SWORD=true, MACE=true, PLATE=true }, primary='STRENGTH' },
    [3] = { itemtypes={ TH_POLE=true, TH_AXE=true, TH_MACE=true, TH_SWORD=true, PLATE=true }, primary='STRENGTH' },
    [5] = { itemtypes={ TH_POLE=true, TH_AXE=true, TH_MACE=true, TH_SWORD=true, AXE=true, SWORD=true, MACE=true, PLATE=true }, primary='STRENGTH' },
  },
  ['DEMONHUNTER'] = {
    [1] = { itemtypes={ WARGLAIVE=true, FIST=true, AXE=true, SWORD=true, LEATHER=true }, primary='AGILITY' },
    [2] = { itemtypes={ WARGLAIVE=true, FIST=true, AXE=true, SWORD=true, LEATHER=true }, primary='AGILITY' },
    [5] = { itemtypes={ WARGLAIVE=true, FIST=true, AXE=true, SWORD=true, LEATHER=true }, primary='AGILITY' },
  },
  ['DRUID'] = {
    [1] = { itemtypes={ DAGGER=true, MACE=true, MISCARM=true, TH_MACE=true, TH_STAFF=true, TH_POLE=true, LEATHER=true }, primary='INTELLECT' },
    [2] = { itemtypes={ TH_POLE=true, TH_STAFF=true, TH_MACE=true, LEATHER=true }, primary='AGILITY' },
    [3] = { itemtypes={ TH_POLE=true, TH_STAFF=true, TH_MACE=true, LEATHER=true }, primary='AGILITY' },
    [4] = { itemtypes={ TH_POLE=true, DAGGER=true, MACE=true, MISCARM=true, TH_MACE=true, TH_STAFF=true, LEATHER=true }, primary='INTELLECT' },
    [5] = { itemtypes={ TH_POLE=true, TH_STAFF=true, TH_MACE=true, DAGGER=true, MACE=true, MISCARM=true, LEATHER=true }, primary='AGILITY' },
  },
  ['EVOKER'] = {
    [1] = { itemtypes={ DAGGER=true, FIST=true, TH_MACE=true, MACE=true, TH_AXE=true, AXE=true, TH_SWORD=true, SWORD=true, TH_STAFF=true, MAIL=true }, primary='INTELLECT' },
    [2] = { itemtypes={ DAGGER=true, FIST=true, TH_MACE=true, MACE=true, TH_AXE=true, AXE=true, TH_SWORD=true, SWORD=true, TH_STAFF=true, MAIL=true }, primary='INTELLECT' },
    [3] = { itemtypes={ DAGGER=true, FIST=true, TH_MACE=true, MACE=true, TH_AXE=true, AXE=true, TH_SWORD=true, SWORD=true, TH_STAFF=true, MAIL=true }, primary='INTELLECT' },
    [5] = { itemtypes={ DAGGER=true, FIST=true, TH_MACE=true, MACE=true, TH_AXE=true, AXE=true, TH_SWORD=true, SWORD=true, TH_STAFF=true, MAIL=true }, primary='INTELLECT' },
  },
  ['HUNTER'] = {
    [1] = { itemtypes={ BOW=true, CROSSBOW=true, GUN=true, MAIL=true }, primary='AGILITY' },
    [2] = { itemtypes={ BOW=true, CROSSBOW=true, GUN=true, MAIL=true }, primary='AGILITY' },
    [3] = { itemtypes={ AXE=true, SWORD=true, DAGGER=true, FIST=true, TH_AXE=true, TH_SWORD=true, TH_STAFF=true, TH_POLE=true, MAIL=true }, primary='AGILITY' },
    [5] = { itemtypes={ BOW=true, CROSSBOW=true, GUN=true, AXE=true, SWORD=true, DAGGER=true, FIST=true, TH_AXE=true, TH_SWORD=true, TH_STAFF=true, TH_POLE=true, MAIL=true }, primary='AGILITY' },
  },
  ['MAGE'] = {
    [1] = { itemtypes={ TH_STAFF=true, WAND=true, MISCARM=true, SWORD=true, DAGGER=true, CLOTH=true }, primary='INTELLECT' },
    [2] = { itemtypes={ TH_STAFF=true, WAND=true, MISCARM=true, SWORD=true, DAGGER=true, CLOTH=true }, primary='INTELLECT' },
    [3] = { itemtypes={ TH_STAFF=true, WAND=true, MISCARM=true, SWORD=true, DAGGER=true, CLOTH=true }, primary='INTELLECT' },
    [5] = { itemtypes={ TH_STAFF=true, WAND=true, MISCARM=true, SWORD=true, DAGGER=true, CLOTH=true }, primary='INTELLECT' },
  },
  ['MONK'] = {
    [1] = { itemtypes={ TH_POLE=true, TH_STAFF=true, FIST=true, AXE=true, SWORD=true, MACE=true, LEATHER=true }, primary='AGILITY' },
    [2] = { itemtypes={ TH_POLE=true, TH_STAFF=true, FIST=true, AXE=true, SWORD=true, MACE=true, LEATHER=true }, primary='INTELLECT' },
    [3] = { itemtypes={ FIST=true, AXE=true, SWORD=true, MACE=true, LEATHER=true }, primary='AGILITY' },
    [5] = { itemtypes={ FIST=true, TH_POLE=true, TH_STAFF=true, AXE=true, SWORD=true, MACE=true, LEATHER=true }, primary='AGILITY' },
  },
  ['PALADIN'] = {
    [1] = { itemtypes={ TH_POLE=true, TH_AXE=true, TH_MACE=true, TH_SWORD=true, AXE=true, MACE=true, SWORD=true, SHIELD=true, MISCARM=true, PLATE=true }, primary='INTELLECT' },
    [2] = { itemtypes={ AXE=true, MACE=true, SWORD=true, SHIELD=true, PLATE=true }, primary='STRENGTH' },
    [3] = { itemtypes={ TH_POLE=true, TH_AXE=true, TH_MACE=true, TH_SWORD=true, PLATE=true }, primary='STRENGTH' },
    [5] = { itemtypes={ TH_POLE=true, TH_AXE=true, TH_MACE=true, TH_SWORD=true, AXE=true, MACE=true, SWORD=true, SHIELD=true, PLATE=true }, primary='STRENGTH' },
  },
  ['PRIEST'] = {
    [1] = { itemtypes={ DAGGER=true, MACE=true, TH_STAFF=true, WAND=true, MISCARM=true, CLOTH=true }, primary='INTELLECT' },
    [2] = { itemtypes={ DAGGER=true, MACE=true, TH_STAFF=true, WAND=true, MISCARM=true, CLOTH=true }, primary='INTELLECT' },
    [3] = { itemtypes={ DAGGER=true, MACE=true, TH_STAFF=true, WAND=true, MISCARM=true, CLOTH=true }, primary='INTELLECT' },
    [5] = { itemtypes={ DAGGER=true, MACE=true, TH_STAFF=true, WAND=true, MISCARM=true, CLOTH=true }, primary='INTELLECT' },
  },
  ['ROGUE'] = {
    [1] = { itemtypes={ DAGGER=true, LEATHER=true }, primary='AGILITY' },
    [2] = { itemtypes={ DAGGER=true, FIST=true, AXE=true, MACE=true, SWORD=true, LEATHER=true }, primary='AGILITY' },
    [3] = { itemtypes={ DAGGER=true, FIST=true, AXE=true, MACE=true, SWORD=true, LEATHER=true }, primary='AGILITY' },
    [5] = { itemtypes={ DAGGER=true, FIST=true, AXE=true, MACE=true, SWORD=true, LEATHER=true }, primary='AGILITY' },
  },
  ['SHAMAN'] = {
    [1] = { itemtypes={ DAGGER=true, FIST=true, AXE=true, MACE=true, TH_STAFF=true, TH_AXE=true, TH_MACE=true, MISCARM=true, SHIELD=true, MAIL=true }, primary='INTELLECT' },
    [2] = { itemtypes={ FIST=true, AXE=true, MACE=true, TH_AXE=true, TH_MACE=true, MISCARM=true, MAIL=true }, primary='AGILITY' },
    [3] = { itemtypes={ DAGGER=true, FIST=true, AXE=true, MACE=true, TH_STAFF=true, TH_AXE=true, TH_MACE=true, MISCARM=true, SHIELD=true, MAIL=true }, primary='INTELLECT' },
    [5] = { itemtypes={ DAGGER=true, FIST=true, AXE=true, MACE=true, TH_STAFF=true, TH_AXE=true, TH_MACE=true, MISCARM=true, SHIELD=true, MAIL=true }, primary='AGILITY' },
  },
  ['WARLOCK'] = {
    [1] = { itemtypes={ SWORD=true, DAGGER=true, TH_STAFF=true, WAND=true, MISCARM=true, CLOTH=true }, primary='INTELLECT' },
    [2] = { itemtypes={ SWORD=true, DAGGER=true, TH_STAFF=true, WAND=true, MISCARM=true, CLOTH=true }, primary='INTELLECT' },
    [3] = { itemtypes={ SWORD=true, DAGGER=true, TH_STAFF=true, WAND=true, MISCARM=true, CLOTH=true }, primary='INTELLECT' },
    [5] = { itemtypes={ SWORD=true, DAGGER=true, TH_STAFF=true, WAND=true, MISCARM=true, CLOTH=true }, primary='INTELLECT' },
  },
  ['WARRIOR'] = {
    [1] = { itemtypes={ TH_POLE=true, TH_AXE=true, TH_MACE=true, TH_SWORD=true, PLATE=true }, primary='STRENGTH' },
    [2] = { itemtypes={ TH_POLE=true, TH_AXE=true, TH_MACE=true, TH_SWORD=true, DAGGER=true, FIST=true, AXE=true, MACE=true, SWORD=true, PLATE=true }, primary='STRENGTH' },
    [3] = { itemtypes={ DAGGER=true, FIST=true, AXE=true, MACE=true, SWORD=true, SHIELD=true, PLATE=true }, primary='STRENGTH' },
    [5] = { itemtypes={ TH_POLE=true, TH_AXE=true, TH_MACE=true, TH_SWORD=true, TH_STAFF=true, DAGGER=true, FIST=true, AXE=true, MACE=true, SWORD=true, SHIELD=true, PLATE=true }, primary='STRENGTH' },
  },
}