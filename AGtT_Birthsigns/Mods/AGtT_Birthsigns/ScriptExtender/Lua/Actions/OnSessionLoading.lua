--- Enable the SyncingSlots Global
function Actions.OnSessionLoading()
  CLUtils.Info("Entering OnSessionLoading", Globals.InfoOverride) -- Register Goals
  Globals.SyncingSlots = true
end
