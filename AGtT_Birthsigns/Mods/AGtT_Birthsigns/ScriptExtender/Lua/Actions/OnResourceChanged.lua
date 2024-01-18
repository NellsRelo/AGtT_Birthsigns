--- Check if entity who'se resource has changed is a valid Atronach Player, and if the
--- resource is a valid Spell Slot. Then transfer the value of Spell Slots to Stunted
--- Spell Slots.
--- @param entity userdata Entity whose Action Resources have changed.
function Actions.OnResourceChanged(entity)
  CLUtils.Info("Entering OnResourceChanged", Globals.InfoOverride)
  if Conditions.IsAtronachPlayer(entity) then
    CLUtils.Info("Subscribed to Action Resources on entity " .. entity.Uuid.EntityUuid, Globals.InfoOverride)
    local slotTable = CLUtils.FilterEntityResources(Globals.ValidSlots, entity.ActionResources.Resources)
    for _, slotObj in pairs(slotTable) do
      if Conditions.IsResourceChanged(entity, slotObj) then
        if slotObj.Name ~= "CL_StuntedSpellSlot" then
          Utils.TransferResource(entity, slotObj)
        elseif slotObj.Name ~= "CL_StuntedSpellSlot" then
          -- TODO: Special Handling Here for setting ModVars when a Stunted Slot is used
          Utils.SetValue(
            entity.Uuid.EntityUuid,
            "CL_StuntedSpellSlot",
            slotObj.Level, "PrevAmount",
            slotObj.Amount
          )
        end
      end
    end
  end
end
