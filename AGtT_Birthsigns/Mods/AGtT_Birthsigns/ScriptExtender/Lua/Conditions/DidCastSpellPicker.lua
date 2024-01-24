function Conditions.DidCastSpellPicker(spellId)
  local res = false
  if CLUtils.IsInTable(Globals.ElfbornSpellPickerSpells, spellId) then
    res = true
  end

  return res
end
