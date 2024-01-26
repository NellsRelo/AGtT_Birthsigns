function Utils.HandleRemoveSpellPicker(character, spell)
  CLUtils.Info("Entering HandleRemoveSpellPicker", Globals.InfoOverride)
  Osi.RemoveSpell(character, Globals.SpellPickers.Apprentice)
  Utils.AddSpellBoost(
    character,
    Globals.ElfbornSpells[CLUtils.GetKeyFromvalue(Globals.ElfbornSpellPickerSpells, spell)]
  )
  Utils.HandleRegisterSpellPickerState(character, true)
end

function Utils.AddSpellBoost(characterId, spell)
  CLUtils.Info("Entering AddSpellBoost", Globals.InfoOverride)
  Osi.AddBoosts(
    characterId,
    "UnlockSpell("
    .. spell .. ",1,"
    .. CLGlobals.ActionResources.SpellSlot .. ",,)",
    "",
    ""
  )
  Utils.RegisterEntity(characterId)
  Globals.CharacterResources[characterId].ApprenticeSpell = spell
end

function Utils.RemoveSpellBoost(characterId, spell)
  CLUtils.Info("Entering RemoveSpellBoost", Globals.InfoOverride)
  Osi.RemoveBoosts(
    characterId,
    "UnlockSpell("
    .. spell .. ",1,"
    .. CLGlobals.ActionResources.SpellSlot .. ",,)",
    1,
    "",
    ""
  )

  Globals.CharacterResources[characterId].ApprenticeSpell = nil
end

function Utils.HandleAddSpellPicker(character)
  CLUtils.Info("Entering HandleAddSpellPicker", Globals.InfoOverride)
  local entityId = string.sub(character, -36)
  Osi.AddSpell(entityId, Globals.SpellPickers.Apprentice, 0, 1)
  Utils.HandleRegisterSpellPickerState(entityId, false)
end

function Utils.HandleRemoveElfbornSpells(character)
  CLUtils.Info("Entering HandleRemoveElfbornSpells", Globals.InfoOverride)
  for _, spell in pairs(Globals.ElfbornSpells) do
    if Osi.HasSpell(character, spell) then
      Utils.RemoveSpellBoost(character, spell)
    end
  end
end

function Utils.FleshCharacter(character)
  CLUtils.Info("Entering OnSessionLoaded", Globals.InfoOverride)
  if type(character) == "string" then
    character = Ext.Entity.Get(character)
  end

  return character
end

function Utils.HandleRegisterSpellPickerState(entityId, isPicked)
  CLUtils.Info("Entering OnSessionLoaded", Globals.InfoOverride)
  entityId = string.sub(entityId, -36)
  Utils.RegisterEntity(entityId)

  Globals.CharacterResources[entityId].SpellPicked = isPicked
  Utils.SyncModVars()
end
