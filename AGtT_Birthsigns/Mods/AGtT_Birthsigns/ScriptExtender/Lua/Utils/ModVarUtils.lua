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

--- Register an Entity's Resource with the Global CharacterResources table
--- @param entityId string UUID of entity
--- @param slotName string Name of Action Resource
function Utils.RegisterEntitySlot(entityId, slotName)
  if not Globals.CharacterResources[entityId][slotName] then
    Globals.CharacterResources[entityId][slotName] = {}
  end
end

--- Register an Entity's Resource at a Given Level with the Global CharacterResources table
--- @param entityId string UUID of entity
--- @param slotName string Name of Action Resource
--- @param slotLevel number Level at which the Action Resource should be present
function Utils.RegisterEntitySlotLevel(entityId, slotName, slotLevel)
  if not Globals.CharacterResources[entityId][slotName]['L' .. tostring(slotLevel)] then
    Globals.CharacterResources[entityId][slotName]['L' .. tostring(slotLevel)] = {}
  end
end

--- Wrapper function to register an Entity, Resource, and Resource Level
--- @param entityId string UUID of entity
--- @param slotName string Name of Action Resource
--- @param slotLevel number Level at which the Action Resource should be present
function Utils.RegisterEntityBootstrap(entityId, slotName, slotLevel)
  Utils.RegisterEntity(entityId)
  Utils.RegisterEntitySlot(entityId, slotName)
  Utils.RegisterEntitySlotLevel(entityId, slotName, slotLevel)
end

--- Set ModVars based on Global CharacterResources table
function Utils.SyncModVars()
  local vars = Ext.Vars.GetModVariables(AGTTBS.UUID)
  vars.AGTTBS_CharacterResources = Globals.CharacterResources
end

-- Set Global CharacterResources table based on ModVars
function Utils.InitCharResourcesOnLoad()
  local vars = Ext.Vars.GetModVariables(AGTTBS.UUID)
  Globals.CharacterResources = vars.AGTTBS_CharacterResources
end

--- Register Action Resources to an Entity in the Global Character Resources table
--- @param entityId string UUID of entity
--- @param slotName string Name of Action Resource
--- @param slotLevel number Level of Action Resource
--- @param args table table containing Current (`slotAmount`) and Previous (`prevSlotAmount`) Amount of Action Resource
function Utils.RegisterSlot(entityId, slotName, slotLevel, args)
  CLUtils.Info("Entering RegisterSlot", Globals.InfoOverride)
  Utils.RegisterEntityBootstrap(entityId, slotName, slotLevel)

  Globals.CharacterResources[entityId][slotName]['L' .. tostring(slotLevel)].Amount = args.slotAmount or 0
  Globals.CharacterResources[entityId][slotName]['L' .. tostring(slotLevel)].PrevAmount = args.prevSlotAmount or
    Utils.GetValue(entityId, slotName, slotLevel, "PrevAmount") or 0
  Utils.SyncModVars()
end

--- Set a key to in CharacterResources[EntityId][SlotName][SlotLevel] to a given value
--- @param entityId string UUID of entity
--- @param slotName string Name of Action Resource
--- @param slotLevel number Level of Action Resource
--- @param key string Name of Value Key - `Amount` or `PrevAmount`
--- @param value number New Value to set
function Utils.SetValue(entityId, slotName, slotLevel, key, value)
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
function Utils.GetValue(entityId, slotName, slotLevel, key)
  CLUtils.Info("Entering GetValue", Globals.InfoOverride)
  Utils.RegisterEntityBootstrap(entityId, slotName, slotLevel)

  if not Globals.CharacterResources[entityId][slotName]['L' .. tostring(slotLevel)][key] then
    Globals.CharacterResources[entityId][slotName]['L' .. tostring(slotLevel)][key] = Globals.ModVarKeyDefaults[key]
  end

  return Globals.CharacterResources[entityId][slotName]['L' .. tostring(slotLevel)][key]
end
