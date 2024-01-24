function Utils.HandleRemoveSpellPicker(character, spell)
  Osi.RemoveSpell(character, spell)
end

function Utils.HandleAddSpellPicker(character)
  Osi.AddSpell(character, Globals.SpellPickers.Apprentice)
end

function Utils.HandleRemoveElfbornSpells(character)
  for _, spell in pairs(Globals.ElfbornSpells) do
    if Osi.HasSpell(character, spell) then
      Osi.RemoveSpell(character, spell)
    end
  end
end

function Utils.FleshCharacter(character)
  if type(character) == "string" then
    character = Ext.Entity.Get(character)
  end

  return character
end
