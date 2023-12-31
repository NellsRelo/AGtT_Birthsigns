Utils = {}

function Utils.RetrieveSlotData(resources)
  CLUtils.Info("Entering RetrieveSlotData", Globals.InfoOverride)
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
  CLUtils.Info("Entering PrepareStuntedResource", Globals.InfoOverride)
  local res = 0
  local found = false
  local resourceData = CLUtils.GetActionResourceData(entity, CLGlobals.ActionResources.CL_StuntedSpellSlot)

  if resourceData then
    for _, resourceObj in pairs(resourceData) do
      if resourceObj.ResourceId == level then
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
  _D(level)
  _D(entity)
  local stuntedSlots = entity.ActionResources.Resources[CLGlobals.ActionResources.CL_StuntedSpellSlot]
  _D(stuntedSlots)
  local res = 0
  for _, resourceObj in pairs(stuntedSlots) do
    if resourceObj.ResourceId == level then
      _D("ResourceID matches Level")
      res = resourceObj.Amount
    end
  end

  return res
end

function Utils.LoadSpellSlotsGroup()
  CLUtils.Info("Entering LoadSpellSlotsGroup", Globals.InfoOverride)
  Globals.ValidSlots = {}
  for _, resource in pairs(Ext.StaticData.Get(CLGlobals.ActionResourceGroups.SpellSlotsGroup, "ActionResourceGroup").ActionResourceDefinitions) do
    if resource ~= CLGlobals.ActionResources.CL_StuntedSpellSlot then
      CLUtils.AddToTable(Globals.ValidSlots, resource)
    end
  end
end

function Utils.RemoveSlotAtLevel(entity, slotObj)
  CLUtils.Info("Entering RemoveSlotAtLevel", Globals.InfoOverride)
  for key, resourceObj in pairs(entity.ActionResources.Resources[slotObj.UUID]) do
    if resourceObj.ResourceId == slotObj.Level then
      entity.ActionResources.Resources[slotObj.UUID][key] = nil
    end
  end
end

function Utils.AddSlotAtLevel(entity, resource, level)
  CLUtils.Info("Entering AddSlotAtLevel", Globals.InfoOverride)
  local isPrepared = Utils.PrepareStuntedResource(entity, level)
end

local function RemoveUnStuntedSlots(resources)
  CLUtils.Info("Entering RemoveUnStuntedSlots", Globals.InfoOverride)
  for _, resourceUUID in pairs(Globals.ValidSlots) do
    resources[resourceUUID] = nil
  end
end
