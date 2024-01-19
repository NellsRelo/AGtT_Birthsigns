function Conditions.IsResourceChanged(entity, resource)
  CLUtils.Info("Entering IsResourceChanged", Globals.InfoOverride)

  return Utils.GetSlotValue(entity.Uuid.EntityUuid, resource.Name, resource.Level, "PrevAmount") ~= resource.Amount
end
