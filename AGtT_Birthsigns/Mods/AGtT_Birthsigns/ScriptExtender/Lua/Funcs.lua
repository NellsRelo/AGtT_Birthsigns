Ext.Require("InitGlobals.lua")

local function ModifyStuntedSlotsBySpell(entity, spell, amount)
  CLUtils.Info("Entering ModifyStuntedSlotsBySpell", true)
  local spellData = Ext.Stats.Get(spell)
  local level = spellData.Level or 1

  if spellData.SpellFlags then
    CLUtils.ModifyEntityResourceValue(entity, CLGlobals.ActionResources.CL_StuntedSpellSlot,
      { Amount = amount, MaxAmount = amount }, level)
  end
end

-- Damaged by Spell = increase Stunted Slots at Spell Level X
Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function (_, target, spell, _, _, _)
  if Utils.ModifySlotConditions(target, spell) then
    ModifyStuntedSlotsBySpell(target, spell, 1)
  end
end)

-- TODO: Listener for Level-Up to apply new Atronach Spell Slot at valid levels

local function RemoveUnStuntedSlots(resources)
  CLUtils.Info("Entering RemoveUnStuntedSlots", true)
  for _, resourceUUID in pairs(Globals.ValidSlots) do
    resources[resourceUUID] = nil
  end
end

-- Add Stunted Slots based on Existing Spell Slots, remove old ones
-- This seems to be undone when loading a save...
Ext.Entity.Subscribe("ActionResources", function (entity, _, _)
  if entity.Uuid and Osi.IsPlayer(entity.Uuid.EntityUuid) and CLUtils.EntityHasPassive(entity, Globals.AtronachPassive) then
    CLUtils.Info("Subscribed to Action Resources on entity " .. entity.Uuid.EntityUuid, true)
    local resources = entity.ActionResources.Resources
    local slotTable = Utils.RetrieveSlotData(resources)

    for _, slotObj in pairs(slotTable) do
      local isPrepared = Utils.PrepareStuntedResource(entity, slotObj.Level)
      local currentAmount = Utils.GetStuntedSlotAmountAtLevel(entity, slotObj.Level) or 0
      local newAmount = currentAmount + slotObj.Amount - isPrepared

      CLUtils.ModifyEntityResourceValue(
        entity,
        CLGlobals.ActionResources.CL_StuntedSpellSlot,
        { Amount = newAmount, MaxAmount = newAmount },
        slotObj.Level)
    end

    RemoveUnStuntedSlots(resources)
    entity:Replicate("ActionResources")
  end

end)

local function OnSessionLoaded()
  Utils.LoadSpellSlotsGroup()
end

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
