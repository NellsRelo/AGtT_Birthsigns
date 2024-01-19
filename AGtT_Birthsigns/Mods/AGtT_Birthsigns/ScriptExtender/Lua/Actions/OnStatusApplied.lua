--- Check if Entity that toggled passive is a Shadow Player with Moonshadow
--- Passive. If so, handle invisibility based on obscurity and whether passive
--- is toggled on
--- @param entity userdata Entity who's toggled passives have changed.
function Actions.OnStatusApplied(entityId, status)
  CLUtils.Info("Entering OnStatusApplied", Globals.InfoOverride)
  if Conditions.IsStatusMoonshadow(status) then
    Utils.HandleShadowToggle(entityId)
  end
end
