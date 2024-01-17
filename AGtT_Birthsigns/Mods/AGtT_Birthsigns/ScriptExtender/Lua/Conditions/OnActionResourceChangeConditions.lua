function Conditions.OnActionResourceChangeConditions(entity)
  CLUtils.Info("Entering OnActionResourceChangeConditions")
  local res = false

  if entity.Uuid and Osi.IsPlayer(entity.Uuid.EntityUuid) == 1 and CLUtils.EntityHasPassive(entity, Globals.AtronachPassive) then
    res = true
  end

  return res
end
