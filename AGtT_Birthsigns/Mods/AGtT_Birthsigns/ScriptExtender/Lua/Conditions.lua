Conditions = {}

function Conditions.ModifySlotConditions(char, spell)
  CLUtils.Info("Entering ModifySlotConditions")
  local res = false

  if CLUtils.EntityHasPassive(char, Globals.AtronachPassive) and CLUtils.HasSpellFlag(spell, { "IsSpell", "IsCantrip" }) and CLUtils.HasSpellFlag(spell, { "IsHarmful" }) then
    res = true
  end

  return res
end

function Conditions.OnActionResourceChangeConditions(entity)
  CLUtils.Info("Entering OnActionResourceChangeConditions")
  local res = false

  if entity.Uuid and Osi.IsPlayer(entity.Uuid.EntityUuid) and CLUtils.EntityHasPassive(entity, Globals.AtronachPassive) then
    res = true
  end

  return res
end

function Conditions.IsResourceStunted(resource)
  CLUtils.Info("Entering IsResourceStunted")

  return resource == CLGlobals.ActionResources.CL_StuntedSpellSlot
end
