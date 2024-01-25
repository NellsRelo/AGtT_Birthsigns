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

    if Conditions.IsApprenticePlayer(entity) and not Conditions.IsSpellPicked(entityId) then
      Utils.HandleAddSpellPicker(entityId)
    end

    Globals.SyncingSlots = false
  end
end
