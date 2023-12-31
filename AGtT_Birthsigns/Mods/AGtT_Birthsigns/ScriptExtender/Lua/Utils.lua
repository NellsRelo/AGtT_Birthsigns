Utils = {}

function Utils.ModifySlotConditions(char, spell)
  CLUtils.Info("Entering ModifySlotConditions", true)
  local res = false

  if CLUtils.EntityHasPassive(char, Globals.AtronachPassive) and CLUtils.HasSpellFlag(spell, { "IsSpell", "IsCantrip" }) and CLUtils.HasSpellFlag(spell, { "IsHarmful" }) then
    res = true
  end

  return res
end

function Utils.RetrieveSlotData(resources)
  CLUtils.Info("Entering RetrieveSlotData", true)
  local res = {}
  for _, resourceUUID in pairs(Globals.ValidSlots) do
    if resources[resourceUUID] then
      for _, resourceObj in pairs(resources[resourceUUID]) do
        CLUtils.AddToTable(res, { Amount = resourceObj.Amount, Level = resourceObj.ResourceId })
      end
    end
  end

  return res
end

-- In case the action resource doesn't exist to be altered
function Utils.PrepareStuntedResource(entity, level)
  local res = 0
  if not CLUtils.GetActionResourceData(entity, CLGlobals.ActionResources.CL_StuntedSpellSlot) then
    CLUtils.ModifyResourceAmount(entity.Uuid.EntityUuid, "CL_StuntedSpellSlot", level, 1)
    res = 1
  end

  return res
end

function Utils.GetStuntedSlotAmountAtLevel(entity, level)
  local stuntedSlots = entity.ActionResources.Resources[CLGlobals.ActionResources.CL_StuntedSpellSlot]
  local res
  for _, resourceObj in pairs(stuntedSlots) do
    if resourceObj.ResourceId == level then
      res = resourceObj.Amount
    end
  end

  return res
end

function Utils.LoadSpellSlotsGroup()
  CLUtils.Info("Entering LoadSpellSlotsGroup", true)
  Globals.ValidSlots = {}
  for _, resource in pairs(Ext.StaticData.Get(CLGlobals.ActionResourceGroups.SpellSlotsGroup, "ActionResourceGroup").ActionResourceDefinitions) do
    if resource ~= CLGlobals.ActionResources.CL_StuntedSpellSlot then
      CLUtils.AddToTable(Globals.ValidSlots, resource)
    end
  end
end
