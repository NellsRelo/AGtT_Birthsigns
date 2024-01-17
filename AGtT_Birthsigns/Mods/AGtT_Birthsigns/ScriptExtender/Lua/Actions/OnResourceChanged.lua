--- Check if entity who'se resource has changed is a valid Atronach Player, and if the
--- resource is a valid Spell Slot. Then transfer the value of Spell Slots to Stunted
--- Spell Slots.
--- @param entity userdata Entity whose Action Resources have changed.
function Actions.OnResourceChanged(entity)
  if Conditions.IsAtronachPlayer(entity) then
    CLUtils.Info("Subscribed to Action Resources on entity " .. entity.Uuid.EntityUuid, Globals.InfoOverride)
    local slotTable = CLUtils.FilterEntityResources(Globals.ValidSlots, entity.ActionResources.Resources)
    for _, slotObj in pairs(slotTable) do
      if Conditions.IsResourceChanged(entity, slotObj) then
        Utils.TransferResource(entity, slotObj)
      end
    end
    -- TODO: Special Handling Here for setting ModVars when a Stunted Slot is used up
  end
end
