--- Enable the SyncingSlots Global
function Actions.OnSessionLoading()
  CLUtils.Info("Entering OnSessionLoading", Globals.InfoOverride)
  Globals.SyncingSlots = true
end
