--- When casting a spell, check if the user is under The Apprentice birthsign, and if so, check if spell is the Spell Picker.
--- @param caster userdata entity targeted by Spell
--- @param spell string ID of Spell
function Actions.OnCast(caster, spell)
  CLUtils.Info("Entering OnCast", Globals.InfoOverride)
  if Conditions.IsApprenticePlayer(caster) and Conditions.DidCastSpellPicker(spell) then
    local entityId = string.sub(caster, -36)
    Utils.HandleRemoveSpellPicker(caster, spell)
  end
end
