--- When hit by a hostile spell, increment the target's stunted slots  on a level
--- based on the spell's level.
--- @param target userdata entity targeted by Spell
--- @param spell string ID of Spell
function Actions.OnHostileSpell(target, spell)
  CLUtils.Info("Entering OnHostileSpell", Globals.InfoOverride)
  if Conditions.ModifySlotConditions(target, spell) then
    Utils.ModifyStuntedSlotsBySpell(target, spell, 1)
  end
end
