function Conditions.DidCastSpellPicker(spellId)
  CLUtils.Info("Entering DidCastSpellPicker", Globals.InfoOverride)
  local res = false
  if CLUtils.IsInTable(Globals.ElfbornSpellPickerSpells, spellId) then
    res = true
  end

  return res
end
