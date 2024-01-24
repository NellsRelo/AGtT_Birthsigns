function Utils.HandleRemoveSpellPicker(character, spell)
  Osi.RemoveSpell(character, Globals.SpellPickers.Apprentice)
  _D(character)
  Utils.AddSpellBoost(
    character,
    Globals.ElfbornSpells[CLUtils.GetKeyFromvalue(Globals.ElfbornSpellPickerSpells, spell)]
  )
  Utils.HandleRegisterSpellPickerState(character, true)
end

function Utils.AddSpellBoost(characterId, spell)
  Osi.AddBoosts(
    characterId,
    "UnlockSpell("
    .. spell .. ",1,"
    .. CLGlobals.ActionResources.SpellSlot .. ",,)",
    "",
    ""
  )
end

function Utils.RemoveSpellBoost(characterId, spell)
  Osi.RemoveBoosts(
    characterId,
    "UnlockSpell("
    .. spell .. ",1,"
    .. CLGlobals.ActionResources.SpellSlot .. ",,)",
    1,
    "",
    ""
  )
end

function Utils.HandleAddSpellPicker(character)
  Osi.AddSpell(character, Globals.SpellPickers.Apprentice, 0, 1)
  Utils.HandleRegisterSpellPickerState(character, false)
end

function Utils.HandleRemoveElfbornSpells(character)
  for _, spell in pairs(Globals.ElfbornSpells) do
    if Osi.HasSpell(character, spell) then
      Utils.RemoveSpellBoost(character, spell)
    end
  end
end

function Utils.FleshCharacter(character)
  if type(character) == "string" then
    character = Ext.Entity.Get(character)
  end

  return character
end

function Utils.HandleRegisterSpellPickerState(entityId, isPicked)
  Utils.RegisterEntity(entityId)

  Globals.CharacterResources[entityId].SpellPicked = isPicked
end
