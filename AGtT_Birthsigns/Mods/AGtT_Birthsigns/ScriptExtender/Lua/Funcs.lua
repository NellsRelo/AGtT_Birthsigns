Ext.Require("InitGlobals.lua")

local function ModifyStuntedSlotsBySpell(entity, spell, amount)
  CLUtils.Info("Entering ModifyStuntedSlotsBySpell", Globals.InfoOverride)
  local spellData = Ext.Stats.Get(spell)
  local level = spellData.Level or 1

  if spellData.SpellFlags then
    CLUtils.ModifyEntityResourceValue(
      entity,
      CLGlobals.ActionResources.CL_StuntedSpellSlot,
      { Amount = amount, MaxAmount = amount },
      level)
  end
end

-- Damaged by Spell = increase Stunted Slots at Spell Level X
Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function (_, target, spell, _, _, _)
  if Conditions.ModifySlotConditions(target, spell) then
    ModifyStuntedSlotsBySpell(target, spell, 1)
  end
end)

-- TODO: Listener for Level-Up to apply new Atronach Spell Slot at valid levels


-- Add Stunted Slots based on Existing Spell Slots, remove old ones
Ext.Entity.Subscribe("ActionResources", function (entity, _, _)
  if Conditions.OnActionResourceChangeConditions(entity) then
    CLUtils.Info("Subscribed to Action Resources on entity " .. entity.Uuid.EntityUuid, Globals.InfoOverride)
    local slotTable = Utils.RetrieveSlotData(entity.ActionResources.Resources)

    for _, slotObj in pairs(slotTable) do
      local isPrepared = Utils.PrepareStuntedResource(entity, slotObj.Level)
      local currentAmount = Utils.GetStuntedSlotAmountAtLevel(entity, slotObj.Level)
      local newAmount = currentAmount + slotObj.Amount - isPrepared

      CLUtils.SetEntityResourceValue(
        entity,
        CLGlobals.ActionResources.CL_StuntedSpellSlot,
        { Amount = newAmount, MaxAmount = newAmount },
        slotObj.Level)

      Utils.RemoveSlotAtLevel(entity, slotObj)
    end

    entity:Replicate("ActionResources")
  end
end)

local function OnSessionLoaded()
  Utils.LoadSpellSlotsGroup()
end

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
