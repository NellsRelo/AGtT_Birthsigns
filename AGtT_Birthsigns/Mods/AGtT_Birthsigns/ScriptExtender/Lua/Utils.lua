Utils = {}


--- Return table of Resources defined in Globals.ValidSlots as belonging to SpellSlotGroup
--- @param resources userdata Entity.ActionResources.Resource
---@return table res table of Resources
function Utils.RetrieveSlotData(resources)
  CLUtils.Info("Entering RetrieveSlotData")
  local res = {}
  for _, resourceUUID in pairs(Globals.ValidSlots) do
    if resources[resourceUUID] then
      for _, resourceObj in pairs(resources[resourceUUID]) do
        CLUtils.AddToTable(res, {
          Amount = resourceObj.Amount,
          Level = resourceObj.ResourceId,
          UUID = resourceUUID,
          Name = CLUtils.GetKeyFromvalue(CLGlobals.ActionResources, resourceUUID)
        })
      end
    end
  end

  return res
end

--- Returns 1 if the Action Resource needs to be manually created via Boost, 0 if not.
--- @param entity userdata
--- @param level number
---@return integer res 1 if Stunted Spell Slot needs to be manually created, 0 if not.
function Utils.PrepareStuntedResource(entity, level)
  CLUtils.Info("Entering PrepareStuntedResource")
  local res = 0
  local found = false
  local resourceData = CLUtils.GetActionResourceData(entity, "CL_StuntedSpellSlot")

  if resourceData then
    for _, resourceObj in pairs(resourceData) do
      if CLUtils.ToInteger(resourceObj.ResourceId) == CLUtils.ToInteger(level) then
        found = true
      end
    end
  end

  if not found then
    CLUtils.ModifyResourceAmount(entity.Uuid.EntityUuid, "CL_StuntedSpellSlot", 1, level)
    res = 1
  end

  return res
end

function Utils.GetStuntedSlotAmountAtLevel(entity, level)
  CLUtils.Info("Entering GetStuntedSlotAmountAtLevel", Globals.InfoOverride)
  local stuntedSlots = entity.ActionResources.Resources[CLGlobals.ActionResources.CL_StuntedSpellSlot]
  local res = 0
  for _, resourceObj in pairs(stuntedSlots) do
    if resourceObj.ResourceId == level then
      res = tonumber(resourceObj.Amount)
    end
  end

  return res
end

function Utils.LoadSpellSlotsGroup()
  CLUtils.Info("Entering LoadSpellSlotsGroup")
  Globals.ValidSlots = {}
  for _, resource in pairs(Ext.StaticData.Get(CLGlobals.ActionResourceGroups.SpellSlotsGroup, "ActionResourceGroup").ActionResourceDefinitions) do
    if resource ~= CLGlobals.ActionResources.CL_StuntedSpellSlot then
      CLUtils.AddToTable(Globals.ValidSlots, resource)
    end
  end
end

--- Modify amounts from a given resource into Stunted Slots, and set the original Resource amounts to Zero.
--- @param entity userdata SE Entity object
--- @param baseResource table Table containing Amount, Level, and UUID
function Utils.TransferSlotsToStunted(entity, baseResource)
  CLUtils.Info("Entering ModifyStuntedSlotsByResource", Globals.InfoOverride)
  local preparationResult = Utils.PrepareStuntedResource(entity, baseResource.Level)
  local delta = baseResource.Amount - preparationResult
  _P(
    "For level " .. baseResource.Level ..
    ": OG Resource amount: " .. baseResource.Amount ..
    ", Amount Prepared: " .. preparationResult ..
    ", Amount to add: " .. delta
  )

  -- Modify Stunted Slots
  CLUtils.ModifyEntityResourceValue(
    entity,
    CLGlobals.ActionResources.CL_StuntedSpellSlot,
    { Amount = delta, MaxAmount = delta },
    baseResource.Level
  )

  Utils.RegisterSlot(
    entity.Uuid.EntityUuid,
    "CL_StuntedSpellSlot",
    baseResource.Level,
    Utils.GetStuntedSlotAmountAtLevel(entity, baseResource.Level)
  )

  -- Remove Base Slots
  CLUtils.SetEntityResourceValue(
    entity,
    baseResource.UUID,
    { Amount = 0, MaxAmount = 0 },
    baseResource.Level
  )

  Utils.RegisterSlot(
    entity.Uuid.EntityUuid,
    baseResource.Name,
    baseResource.Level,
    0
  )
end

function Utils.ModifyStuntedSlotsBySpell(entity, spell, amount)
  CLUtils.Info("Entering ModifyStuntedSlotsBySpell", Globals.InfoOverride)
  local spellData = Ext.Stats.Get(spell)
  local level = spellData.Level or 1

  if spellData.SpellFlags then
    CLUtils.ModifyEntityResourceValue(
      entity,
      CLGlobals.ActionResources.CL_StuntedSpellSlot,
      { Amount = amount, MaxAmount = amount },
      level
    )
  end

  Utils.RegisterSlot(
    entity.Uuid.EntityUuid,
    "CL_StuntedSpellSlot",
    level,
    Utils.GetStuntedSlotAmountAtLevel(entity, level) or 0
  )
end

function Utils.ModifySlotValuesOnSession(entity, resources)
  for resourceName, resourcesAtLevel in pairs(resources) do
    for resourceLevel, resourceAmount in pairs(resourcesAtLevel) do
      CLUtils.SetEntityResourceValue(
        entity,
        CLGlobals.ActionResources[resourceName],
        { Amount = resourceAmount, MaxAmount = resourceAmount },
        resourceLevel
      )
    end
  end
end

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

function Utils.SyncModVars()
  local vars = Ext.Vars.GetModVariables(AGTTBS.UUID)
  vars.AGTTBS_CharacterResources = Globals.CharacterResources
end

function Utils.RegisterEntity(entityId)
  if not Globals.CharacterResources[entityId] then
    Globals.CharacterResources[entityId] = {}
  end
end

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
