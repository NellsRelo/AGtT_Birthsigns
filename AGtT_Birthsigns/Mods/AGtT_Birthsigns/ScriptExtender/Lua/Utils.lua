Utils = {}

local function ToInteger(number)
  return math.floor(tonumber(number) or error("Could not cast '" .. tostring(number) .. "' to number.'"))
end

function Utils.RetrieveSlotData(resources)
  CLUtils.Info("Entering RetrieveSlotData")
  local res = {}
  for _, resourceUUID in pairs(Globals.ValidSlots) do
    if resources[resourceUUID] then
      for _, resourceObj in pairs(resources[resourceUUID]) do
        CLUtils.AddToTable(res, {
          Amount = resourceObj.Amount,
          Level = resourceObj.ResourceId,
          UUID = resourceUUID
        })
      end
    end
  end

  return res
end

-- In case the action resource doesn't exist to be altered
function Utils.PrepareStuntedResource(entity, level)
  CLUtils.Info("Entering PrepareStuntedResource")
  local res = 0
  local found = false
  local resourceData = CLUtils.GetActionResourceData(entity, "CL_StuntedSpellSlot")

  if resourceData then
    for _, resourceObj in pairs(resourceData) do
      if ToInteger(resourceObj.ResourceId) == ToInteger(level) then
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
      res = ToInteger(resourceObj.Amount)
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
  local isPrepared = Utils.PrepareStuntedResource(entity, level)
  local currentAmount = Utils.GetStuntedSlotAmountAtLevel(entity, level)
  _P(
    "isPrepared = " .. isPrepared ..
    ", delta = " .. tostring(ToInteger(delta)) ..
    ", level is " .. level ..
    ", currentAmount is " .. currentAmount)
  return tonumber(currentAmount) + tonumber(delta) - tonumber(isPrepared)
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

function Utils.ModifyStuntedSlotsByResource(entity, baseResource)
  CLUtils.Info("Entering ModifyStuntedSlotsByResource", Globals.InfoOverride)
  local isPrepared = Utils.PrepareStuntedResource(entity, baseResource.Level)
  local delta = baseResource.Level - isPrepared
  CLUtils.ModifyEntityResourceValue(
    entity,
    CLGlobals.ActionResources.CL_StuntedSpellSlot,
    { Amount = delta, MaxAmount = delta },
    baseResource.Level
  )

  CLUtils.SetEntityResourceValue(
    entity,
    baseResource.UUID,
    { Amount = 0, MaxAmount = 0 },
    baseResource.Level)
end
