--- Generate ValidSlots Global, and apply any saved ModVars to the relevant
--- characters.
function Actions.OnSessionLoaded()
  Globals.ValidSlots = CLUtils.LoadSpellSlotsGroupToArray(Globals.ValidSlots, Conditions.IsResourceNotStunted)
  local vars = Utils.GetModVars()

  for entityId, resources in pairs(vars.AGTTBS_CharacterResources) do
    local entity = Ext.Entity.Get(entityId)

    Utils.SyncSlotValuesOnSession(entity, resources)
  end
end
