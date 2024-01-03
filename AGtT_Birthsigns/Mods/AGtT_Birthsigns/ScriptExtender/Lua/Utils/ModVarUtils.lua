--- Retrieve ModVars
---@return table characterResourceTable
function Utils.GetModVars()
  local characterResourceTable = {}
  local vars = Ext.Vars.GetModVariables(AGTTBS.UUID)
  if not vars.AGTTBS_CharacterResources then
    vars.AGTTBS_CharacterResources = {}
    Ext.Vars.SyncModVariables(AGTTBS.UUID)
  end
  characterResourceTable = vars
  return characterResourceTable
end

--- Register an Entity with the Global CharacterResources table
--- @param entityId string UUID of entity
function Utils.RegisterEntity(entityId)
  if not Globals.CharacterResources[entityId] then
    Globals.CharacterResources[entityId] = {}
  end
end

--- Set ModVars based on Global CharacterResources table
function Utils.SyncModVars()
  local vars = Ext.Vars.GetModVariables(AGTTBS.UUID)
  vars.AGTTBS_CharacterResources = Globals.CharacterResources
end

--- Register Action Resources to an Entity in the Global Character Resources table
--- @param entityId string UUID of entity
--- @param slotName string Name of Action Resource
--- @param slotLevel number Level of Action Resource
--- @param slotAmount number Current Amount of Action Resource
function Utils.RegisterSlot(entityId, slotName, slotLevel, slotAmount)
  Utils.RegisterEntity(entityId)

  if not Globals.CharacterResources[entityId][slotName] then
    Globals.CharacterResources[entityId][slotName] = {}
  end

  if not Globals.CharacterResources[entityId][slotName]['L' .. tostring(slotLevel)] then
    Globals.CharacterResources[entityId][slotName]['L' .. tostring(slotLevel)] = 0
  end
  Globals.CharacterResources[entityId][slotName]['L' .. tostring(slotLevel)] = slotAmount or 0

  Utils.SyncModVars()
end
