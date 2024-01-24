function Conditions.IsSpellPicked(entityId)
  Utils.RegisterEntity(entityId)
  return Globals.CharacterResources[entityId].SpellPicked or false
end
