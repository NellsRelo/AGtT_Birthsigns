function Conditions.IsStatusMoonshadow(status)
  CLUtils.Info("Entering IsStatusMoonshadow with status " .. status, Globals.InfoOverride)
  return status == Globals.ShadowStatus
end
