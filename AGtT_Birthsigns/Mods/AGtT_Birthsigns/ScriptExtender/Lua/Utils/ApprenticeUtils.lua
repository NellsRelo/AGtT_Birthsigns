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
end

function Utils.HandleAddSpellPicker(character)
  CLUtils.Info("Entering HandleAddSpellPicker", Globals.InfoOverride)
  Osi.AddSpell(character, Globals.SpellPickers.Apprentice, 0, 1)
  Utils.HandleRegisterSpellPickerState(character, false)
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
  Utils.RegisterEntity(entityId)

  Globals.CharacterResources[entityId].SpellPicked = isPicked
end
