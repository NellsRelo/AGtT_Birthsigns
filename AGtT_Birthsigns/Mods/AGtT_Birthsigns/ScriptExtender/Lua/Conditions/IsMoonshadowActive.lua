function Conditions.IsMoonshadowActive(entity)
  CLUtils.Info("Entering IsMoonshadowActive", Globals.InfoOverride)
  return entity.ServerToggledPassives.Passives.AGTT_BS_Moonshadow
end
