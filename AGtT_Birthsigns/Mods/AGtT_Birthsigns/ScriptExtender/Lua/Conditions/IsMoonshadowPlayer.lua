function Conditions.IsMoonshadowPlayer(entity)
  CLUtils.Info("Entering IsMoonshadowPlayer", Globals.InfoOverride)
  local res = false

  if entity.Uuid and Osi.IsPlayer(entity.Uuid.EntityUuid) == 1 and
    CLUtils.EntityHasPassive(entity, Globals.ShadowPassive) then
    res = true
  end

  return res
end
