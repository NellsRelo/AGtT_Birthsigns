Utils = {}

function Utils.LoadSpellSlotsGroup()
  for _, resource in pairs(Ext.StaticData.Get("03b17647-161a-42e1-9660-5ba517e80ad2", "ActionResourceGroup").ActionResourceDefinitions) do
    if resource ~= CLGlobals.ActionResources.CL_StuntedSpellSlot then
      table.insert(Globals.ValidSlots, resource)
    end
  end
end

function Utils.ModifySlotAmount(entityId, slot, delta, level)
  local deltaTable = {
    Amount = delta,
    MaxAmount = delta
  }

  level = level or 0
  CLUtils.ModifyEntityResourceValue(entityId, slot, deltaTable, level)
end

function Utils.ModifySlotConditions(char, spell)
  local res = false

  if CLUtils.EntityHasPassive(char, Globals.AtronachPassive) and Osi.SpellHasSpellFlag(spell, "IsSpell") then
    res = true
  end

  return true
end
