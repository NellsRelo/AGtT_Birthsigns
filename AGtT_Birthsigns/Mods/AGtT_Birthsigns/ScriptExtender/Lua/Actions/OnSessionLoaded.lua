--- Generate ValidSlots Global, and apply any saved ModVars to the relevant
--- characters.
function Actions.OnSessionLoaded()
  CLUtils.Info("Entering OnSessionLoaded", Globals.InfoOverride)
  Globals.SyncingSlots = true
  Globals.ValidSlots = CLUtils.LoadSpellSlotsGroupToArray(Globals.ValidSlots)
  local vars = Utils.GetModVars()

  for entityId, _ in pairs(vars.AGTTBS_CharacterResources) do
    local entity = Ext.Entity.Get(entityId)
    if Conditions.IsAtronachPlayer(entity) then
      Utils.NullifySpellSlots(entity)
    end

    if Conditions.IsApprenticePlayer(entity) and not Conditions.SpellPicked(entity, Globals.SpellPickers.Apprentice) then
      
    end
  end
  Globals.SyncingSlots = false

end
