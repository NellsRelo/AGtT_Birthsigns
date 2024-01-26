function Actions.OnLevelGameplayStarted()
  CLUtils.Info("Entering OnLevelGameplayStarted", Globals.InfoOverride)

  local party = Osi.DB_PartyMembers:Get(nil)

  for _, character in pairs(party) do
    local entityId = string.sub(character[1], -36)
    Utils.RegisterEntity(entityId)
    local entity = Utils.FleshCharacter(entityId)
    if Conditions.IsAtronachPlayer(entity) then
      Utils.NullifySpellSlots(entity)
      Utils.SetStuntedSlotsFromModvars(entity)
    end

    if Conditions.IsApprenticePlayer(entity) then
      if Conditions.IsSpellPicked(entityId) then
        Utils.AddSpellBoost(entityId, Globals.CharacterResources[entityId].ApprenticeSpell)
      else
        Utils.HandleAddSpellPicker(entityId)
      end
    end

    Globals.SyncingSlots = false
  end
end
