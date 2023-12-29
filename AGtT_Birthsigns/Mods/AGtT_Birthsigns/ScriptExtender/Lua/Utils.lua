Utils = {}

function Utils.ModifySlotConditions(char, spell)
  CLUtils.Info("Entering ModifySlotConditions", true)
  local res = false

  if CLUtils.EntityHasPassive(char, Globals.AtronachPassive) and CLUtils.HasSpellFlag(spell, { "IsSpell" }) then
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
        table.insert(res, { Amount = resourceObj.Amount, Level = resourceObj.ResourceId })
      end
    end
  end

  return res
end

