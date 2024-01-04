Ext.Require("InitGlobals.lua")

-- Damaged by Spell = increase Stunted Slots at Spell Level X
Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function (_, target, spell, _, _, _)
  if Conditions.ModifySlotConditions(target, spell) then
    Utils.ModifyStuntedSlotsBySpell(target, spell, 1)
  end
end)

-- TODO: Listener for Level-Up to apply new Atronach Spell Slot at valid levels

-- Add Stunted Slots based on Existing Spell Slots, remove old ones
Ext.Entity.Subscribe("ActionResources", function (entity, _, _)
  local vars = Utils.GetModVars()
  if Conditions.OnActionResourceChangeConditions(entity) then
    Utils.RegisterEntity(entity.Uuid.EntityUuid)
    CLUtils.Info("Subscribed to Action Resources on entity " .. entity.Uuid.EntityUuid, Globals.InfoOverride)
    local slotTable = CLUtils.FilterEntityResources(Globals.ValidSlots, entity.ActionResources.Resources)
    _D(slotTable)
    for _, slotObj in pairs(slotTable) do
      if slotObj.Amount then
        Utils.TransferSlotsToStunted(entity, slotObj)
      end
    end
    _D(vars)
  end
end)

local function OnSessionLoaded()
  Globals.ValidSlots = CLUtils.LoadSpellSlotsGroupToArray(Globals.ValidSlots, Conditions.IsResourceNotStunted)

  local vars = Utils.GetModVars()
  for entityId, resources in pairs(vars.AGTTBS_CharacterResources) do
    local entity = Ext.Entity.Get(entityId)

    Utils.SyncSlotValuesOnSession(entity, resources)
  end
end

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
