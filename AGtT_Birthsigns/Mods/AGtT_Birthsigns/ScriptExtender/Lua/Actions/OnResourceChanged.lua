--- Check if entity who'se resource has changed is a valid Atronach Player, and if the
--- resource is a valid Spell Slot. Then transfer the value of Spell Slots to Stunted
--- Spell Slots.
--- @param entity userdata Entity whose Action Resources have changed.
function Actions.OnResourceChanged(entity)
  CLUtils.Info("Entering OnResourceChanged", Globals.InfoOverride)
  if Conditions.IsAtronachPlayer(entity) then
    CLUtils.Info("Subscribed to Action Resources on entity " .. entity.Uuid.EntityUuid, Globals.InfoOverride)
    Utils.CallForTransfer(entity, true, Conditions.IsResourceChanged)
  end
end
