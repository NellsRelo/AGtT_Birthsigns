--- Generate ValidSlots Global, and apply any saved ModVars to the relevant
--- characters.
function Actions.OnSessionLoaded()
  CLUtils.Info("Entering OnSessionLoaded", Globals.InfoOverride)
  Globals.SyncingSlots = true
  Globals.ValidSlots = CLUtils.LoadSpellSlotsGroupToArray(Globals.ValidSlots)
  Globals.CharacterResources = Utils.GetModVars().AGTTBS_CharacterResources
end
