function Conditions.IsResourceChanged(entity, resource)
  CLUtils.Info("Entering IsResourceChanged")

  return Utils.GetValue(entity.Uuid.EntityUuid, resource.Name, resource.Level, "PrevAmount") ~= resource.Amount
end
