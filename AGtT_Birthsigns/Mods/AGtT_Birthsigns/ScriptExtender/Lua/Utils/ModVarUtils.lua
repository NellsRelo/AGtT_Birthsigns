--- Retrieve ModVars
---@return table characterResourceTable
function Utils.GetModVars()
  CLUtils.Info("Entering GetModVars", Globals.InfoOverride)
  local characterResourceTable = {}
  local vars = Ext.Vars.GetModVariables(AGTTBS.UUID)
  if not vars.AGTTBS_CharacterResources then
    vars.AGTTBS_CharacterResources = {}
    Ext.Vars.SyncModVariables(AGTTBS.UUID)
  end
  characterResourceTable = vars
  return characterResourceTable
end

--- Set ModVars based on Global CharacterResources table
function Utils.SyncModVars()
  CLUtils.Info("Entering SyncModVars", Globals.InfoOverride)
  local vars = Ext.Vars.GetModVariables(AGTTBS.UUID)
  vars.AGTTBS_CharacterResources = Globals.CharacterResources
end

--- Wrapper function to register an Entity to ModVars
--- @param entityId string UUID of entity
function Utils.RegisterEntity(entityId)
  CLUtils.Info("Entering RegisterEntity", Globals.InfoOverride)
  if not Globals.CharacterResources[entityId] then
    Globals.CharacterResources[entityId] = {}
  end
end

--- Wrapper function to register an Entity's' Resource, and Resource Level
--- @param entityId string UUID of entity
--- @param slotName string Name of Action Resource
--- @param slotLevel number Level at which the Action Resource should be present
function Utils.RegisterEntityBootstrap(entityId, slotName, slotLevel)
  CLUtils.Info("Entering RegisterEntityBootstrap", Globals.InfoOverride)
  Utils.RegisterEntity(entityId)

  if not Globals.CharacterResources[entityId][slotName] then
    Globals.CharacterResources[entityId][slotName] = {}
  end
  if not Globals.CharacterResources[entityId][slotName]['L' .. tostring(slotLevel)] then
    Globals.CharacterResources[entityId][slotName]['L' .. tostring(slotLevel)] = {}
  end
end

--- Set a key to in CharacterResources[EntityId][SlotName][SlotLevel] to a given value
--- @param entityId string UUID of entity
--- @param slotName string Name of Action Resource
--- @param slotLevel number Level of Action Resource
--- @param key string Name of Value Key - `Amount` or `PrevAmount`
--- @param value number New Value to set
function Utils.SetSlotValue(entityId, slotName, slotLevel, key, value)
  CLUtils.Info("Entering SetValue", Globals.InfoOverride)
  Utils.RegisterEntityBootstrap(entityId, slotName, slotLevel)

  Globals.CharacterResources[entityId][slotName]['L' .. tostring(slotLevel)][key] = value
  Utils.SyncModVars()
end

--- Retrieve the value of a given key in CharacterResources for an entity, resource,
--- and level. If nonexistant, set to default value
--- @param entityId string UUID of entity
--- @param slotName string Name of Action Resource
--- @param slotLevel number Level of Action Resource
--- @param key string Name of Value Key - `Amount` or `PrevAmount`
---@return number
function Utils.GetSlotValue(entityId, slotName, slotLevel, key)
  CLUtils.Info("Entering GetValue", Globals.InfoOverride)
  Utils.RegisterEntityBootstrap(entityId, slotName, slotLevel)

  if not Globals.CharacterResources[entityId][slotName]['L' .. tostring(slotLevel)][key] then
    Globals.CharacterResources[entityId][slotName]['L' .. tostring(slotLevel)][key] = Globals.ModVarKeyDefaults[key]
  end

  return Globals.CharacterResources[entityId][slotName]['L' .. tostring(slotLevel)][key]
end
