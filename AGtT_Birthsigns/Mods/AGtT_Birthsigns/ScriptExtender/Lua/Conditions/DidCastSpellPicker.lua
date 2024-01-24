function Conditions.DidCastSpellPicker(spellId)
  local res = false
  if Globals.SpellPickers.Apprentice == spellId then
    res = true
  end

  return res
end
