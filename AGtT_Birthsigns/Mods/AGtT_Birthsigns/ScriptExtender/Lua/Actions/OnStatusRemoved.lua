--- Check if Entity that toggled passive is a Shadow Player with Moonshadow
--- Passive. If so, handle invisibility based on obscurity and whether passive
--- is toggled on
--- @param entityId string Entity who's toggled passives have changed.
--- @param status string status that's been removed
function Actions.OnStatusRemoved(entityId, status)
  CLUtils.Info("Entering OnStatusRemoved", Globals.InfoOverride)
  if Conditions.IsStatusMoonshadow(status) then
    Utils.HandleShadowToggle(entityId, true)
  end
end
