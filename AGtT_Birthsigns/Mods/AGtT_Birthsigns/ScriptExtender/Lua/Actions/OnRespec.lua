--- Check if entity who'se resource has changed is a valid Atronach Player, and if the
--- resource is a valid Spell Slot. Then transfer the value of Spell Slots to Stunted
--- Spell Slots.
--- @param character string Entity whose Action Resources have changed.
function Actions.OnRespec(character)
  CLUtils.Info("Entering OnRespec", Globals.InfoOverride)
  character = string.sub(character, -36)
  local entity = Ext.Entity.Get(character)
  if Conditions.IsAtronachPlayer(entity) then
    CLUtils.Info("Removing Stunted Slots from Player", Globals.InfoOverride)
    Utils.RemoveStuntedSlots(entity)
    Utils.CallForTransfer(entity)
  end

  if Conditions.IsApprenticePlayer(character) then
    Utils.HandleRemoveElfbornSpells(character)
    Utils.HandleAddSpellPicker(character)
  end
end
