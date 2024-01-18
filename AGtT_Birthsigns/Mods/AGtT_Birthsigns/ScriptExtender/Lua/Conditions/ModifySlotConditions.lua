function Conditions.ModifySlotConditions(char, spell)
  CLUtils.Info("Entering ModifySlotConditions", Globals.InfoOverride)
  local res = false

  if CLUtils.EntityHasPassive(char, Globals.AtronachPassive) and CLUtils.HasSpellFlag(spell, { "IsSpell", "IsCantrip" }) and CLUtils.HasSpellFlag(spell, { "IsHarmful" }) then
    res = true
  end

  return res
end
