function Conditions.IsApprenticePlayer(entity)
  CLUtils.Info("Entering IsAtronachPlayer", Globals.InfoOverride)
  entity = Utils.FleshCharacter(entity)
  local res = false

  if entity.Uuid and Osi.IsPlayer(entity.Uuid.EntityUuid) == 1 and
    CLUtils.EntityHasPassive(entity, Globals.ApprenticePassive) then
    res = true
  end

  return res
end
