Utils = {}

function Utils.LoadSpellSlotsGroup()
  for _, resource in pairs(Ext.StaticData.Get(CLGlobals.ActionResourceGroups.SpellSlotsGroup, "ActionResourceGroup").ActionResourceDefinitions) do
    if resource ~= CLGlobals.ActionResources.CL_StuntedSpellSlot then
      CLUtils.AddToTable(Globals.ValidSlots, resource)
    end
  end
end

function Utils.ModifySlotAmount(entityId, slot, delta, level)
  Osi.AddBoosts(entityId, "ActionResource(" .. slot .. "," .. level .. delta .. ")", "", "")
end

function Utils.ModifySlotConditions(char, spell)
  local res = false

  if CLUtils.EntityHasPassive(char, Globals.AtronachPassive) and Utils.HasSpellFlag(spell, { "IsSpell" }) then
    res = true
  end

  return res
end

function Utils.HasSpellFlag(spell, flags)
  local found = false
  local spellData = Ext.Stats.Get(spell)
  for _, flag in pairs(spellData.SpellFlags) do
    if CLUtils.IsInTable(flags, flag) then
      found = true
    end
  end
  return found
end

function Utils.GetPlayableCharacters()
  return Osi.DB_Players:Get(nil)
end

function Utils.IsEntityInPlayers(entityId)
  local found = false
  for _, player in pairs(Utils.GetPlayableCharacters()) do
    if entityId == string.sub(player[1], -36) then
      found = true
    end
  end

  return found
end

function Utils.RetrieveSlotData(resources)
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

