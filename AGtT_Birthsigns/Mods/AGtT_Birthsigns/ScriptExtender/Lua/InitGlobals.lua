AGTTBS = {}
AGTTBS.UUID = "33d8dcef-c9e2-4e19-9a90-86f6e35d065a"
AGTTBS.modTableKey = "AGtT_Birthsigns"
AGTTBS.modPrefix = "AGTTBS"
AGTTBS.modVersion = Ext.Mod.GetMod(AGTTBS.UUID).Info.ModVersion
Mods.AGTTBS = Mods.AGtT_Birthsigns

Ext.Vars.RegisterModVariable(AGTTBS.UUID, "AGTTBS_CharacterResources", {
  Server = true, Client = true, SyncToClient = true, SyncOnWrite = true, Persistent = true
})

Ext.Require("Globals.lua")
Ext.Require("Utils/_init.lua")

local clImports = {}
clImports[1] = "Globals"
clImports[2] = "Strings"
clImports[3] = "DictUtils"
clImports[4] = "Utils"
clImports[5] = "Validators"

CLGlobals, CLStrings, CLDictUtils, CLUtils, CLValidators = Mods.CommunityLibrary.Import(clImports)

