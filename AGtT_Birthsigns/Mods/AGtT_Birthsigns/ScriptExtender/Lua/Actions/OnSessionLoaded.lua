--- Generate ValidSlots Global, and apply any saved ModVars to the relevant
--- characters.
function Actions.OnSessionLoaded()
  CLUtils.Info("Entering OnSessionLoaded", Globals.InfoOverride)
  Globals.SyncingSlots = true
  Globals.ValidSlots = CLUtils.LoadSpellSlotsGroupToArray(Globals.ValidSlots)
  local vars = Utils.GetModVars()

  for entityId, resources in pairs(vars.AGTTBS_CharacterResources) do
    local entity = Ext.Entity.Get(entityId)
    Utils.SyncSlotValuesOnSession(entity, resources)
  end
  _P("Globals finished Syncing")
  Globals.SyncingSlots = false
end
