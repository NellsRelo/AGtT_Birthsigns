--- Generate ValidSlots Global, and apply any saved ModVars to the relevant
--- characters.
function Actions.OnSessionLoaded()
  CLUtils.Info("Entering OnSessionLoaded", Globals.InfoOverride)
  Globals.SyncingSlots = true
  Globals.ValidSlots = CLUtils.LoadSpellSlotsGroupToArray(Globals.ValidSlots)
  local vars = Utils.GetModVars()
  Globals.CharacterResources = vars.AGTTBS_CharacterResources
  for entityId, _ in pairs(Globals.CharacterResources) do
    local entity = Ext.Entity.Get(entityId)
    if Conditions.IsAtronachPlayer(entity) then
      Utils.NullifySpellSlots(entity)
      Utils.SetStuntedSlotsFromModvars(entity)
    end

    if Conditions.IsApprenticePlayer(entity) and not Conditions.IsSpellPicked(entityId) then
      Utils.HandleAddSpellPicker(entityId)
    end
  end
  Globals.SyncingSlots = false
end
