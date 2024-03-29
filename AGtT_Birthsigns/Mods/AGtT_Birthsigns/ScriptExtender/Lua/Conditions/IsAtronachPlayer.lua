function Conditions.IsAtronachPlayer(entity)
  CLUtils.Info("Entering IsAtronachPlayer", Globals.InfoOverride)
  entity = Utils.FleshCharacter(entity)
  local res = false

  if entity.Uuid and CLUtils.EntityHasPassive(entity, Globals.AtronachPassive) then
    res = true
  end

  return res
end
