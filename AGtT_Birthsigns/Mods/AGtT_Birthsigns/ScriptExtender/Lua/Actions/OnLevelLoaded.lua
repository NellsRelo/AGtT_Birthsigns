function Actions.OnLevelGameplayStarted()
  CLUtils.Info("Entering OnLevelGameplayStarted", Globals.InfoOverride)

  local party = Osi.DB_PartyMembers:Get(nil)

  for _, character in pairs(party) do
    Utils.RegisterEntity(character[1])
    local entity = Utils.FleshCharacter(character[1])

    if Conditions.IsApprenticePlayer(entity) and not Conditions.IsSpellPicked(character[1]) then
      Utils.HandleAddSpellPicker(character[1])
    end
  end
end
