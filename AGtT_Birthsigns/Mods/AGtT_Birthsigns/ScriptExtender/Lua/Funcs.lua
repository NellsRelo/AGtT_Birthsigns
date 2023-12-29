Ext.Require("InitGlobals.lua")

local function ModifyStuntedSlotsBySpell(entity, spell, amount)
  local spellData = Ext.Stats.Get(spell)
  local level = spellData.Level or 1

  if spellData.SpellFlags then
    Utils.ModifySlotAmount(entity, "CL_StuntedSpellSlot", amount, level)
  end
end

-- Cast Spell = reduce Stunted Slots
Ext.Osiris.RegisterListener("CastSpell", 5, "after", function (char, spell, _, _, _)
  if Utils.ModifySlotConditions(char, spell) then
    ModifyStuntedSlotsBySpell(char, spell, -1)
  end
end)

-- Damaged by Spell = increase Stunted Slots at Spell Level X
Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function (_, target, spell, _, _, _)
  if Utils.ModifySlotConditions(target, spell) then
    ModifyStuntedSlotsBySpell(target, spell, 1)
  end
end)

local function RemoveUnStuntedSlots(resources)
  for _, resourceUUID in pairs(Globals.ValidSlots) do
    resources[resourceUUID] = nil
  end
end

-- Add Stunted Slots based on Existing Spell Slots, remove old ones
Ext.Entity.Subscribe("ActionResources", function (entity, _, _)
  if Utils.IsEntityInPlayers(entity) and CLUtils.EntityHasPassive(entity, Globals.AtronachPassive) then
    local resources = entity.ActionResources.Resources
    local slotTable = Utils.RetrieveSlotData(resources)

    for _, slotObj in pairs(slotTable) do
      Utils.ModifySlotAmount(entity, "CL_StuntedSpellSlot", slotObj.Level, slotObj.Amount)
    end

    RemoveUnStuntedSlots(resources)
  end
end)
