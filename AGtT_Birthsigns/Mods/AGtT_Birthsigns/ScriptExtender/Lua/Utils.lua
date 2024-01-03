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
      res = CLUtils.ToInteger(resourceObj.Amount)
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

function Utils.RemoveSlotAtLevel(entity, slotObj)
  CLUtils.Info("Entering RemoveSlotAtLevel")
  for key, resourceObj in pairs(entity.ActionResources.Resources[slotObj.UUID]) do
    if resourceObj.ResourceId == slotObj.Level then
      entity.ActionResources.Resources[slotObj.UUID][key].Amount = 0
      entity.ActionResources.Resources[slotObj.UUID][key].MaxAmount = 0
    end
  end
end

function Utils.CalcNewStuntedSlotAmount(entity, delta, level)
  CLUtils.Info("Entering CalcNewStuntedSlotAmount", Globals.InfoOverride)
  local preparationResult = Utils.PrepareStuntedResource(entity, level)
  local currentAmount = Utils.GetStuntedSlotAmountAtLevel(entity, level)
  _P(
    "preparationResult = " .. preparationResult ..
    ", delta = " .. tostring(CLUtils.ToInteger(delta)) ..
    ", level is " .. level ..
    ", currentAmount is " .. currentAmount)
  return tonumber(currentAmount) + tonumber(delta) - tonumber(preparationResult)
end

function Utils.SetResources(entity, baseResource)
  CLUtils.Info("Entering SetResources", Globals.InfoOverride)
  local newAmount = Utils.CalcNewStuntedSlotAmount(entity, baseResource.Amount, baseResource.Level)
  _P("OG Resource amount: " .. baseResource.Amount .. ", Newly Calculated Amount: " .. newAmount)
  CLUtils.SetEntityResourceValue(
    entity,
    CLGlobals.ActionResources.CL_StuntedSpellSlot,
    { Amount = newAmount, MaxAmount = newAmount },
    baseResource.Level)

  CLUtils.SetEntityResourceValue(
    entity,
    baseResource.UUID,
    { Amount = 0, MaxAmount = 0 },
    baseResource.Level)
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
    level,
    Utils.GetStuntedSlotAmountAtLevel(entity, level)
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
    Utils.GetStuntedSlotAmountAtLevel(entity, level)
  )
end

function Utils.GetModVars()
  local vars = Ext.Vars.GetModVariables(AGTTBS.UUID)
  if not vars.CharacterResources then
    vars.CharacterResources = {}
  end
end

function Utils.RegisterEntity(entityId)
  local vars = Utils.GetModVars()
  if not vars.CharacterResources[entityId] then
    vars.CharacterResources[entityId] = {}
  end
end

function Utils.RegisterSlot(entityId, slotName, slotLevel, slotAmount)
  Utils.RegisterEntity(entityId)

  local vars = Utils.GetModVars()
  vars.CharacterResources[entityId][slotName][slotLevel] = slotAmount
end
