--- When casting a spell, check if the user is under The Apprentice birthsign, and if so, check if spell is the Spell Picker.
--- @param caster userdata entity targeted by Spell
--- @param spell string ID of Spell
function Actions.OnCast(caster, spell)
  CLUtils.Info("Entering OnHostileSpell", Globals.InfoOverride)
  if Conditions.IsApprenticePlayer and Conditions.DidCastSpellPicker(spell) then
    Utils.HandleRemoveSpellPicker(caster, spell)
  end
end
