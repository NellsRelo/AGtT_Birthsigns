function Conditions.IsSpellPicked(entityId)
  CLUtils.Info("Entering IsSpellPicked", Globals.InfoOverride)
  Utils.RegisterEntity(entityId)
  return Globals.CharacterResources[entityId].SpellPicked or false
end
