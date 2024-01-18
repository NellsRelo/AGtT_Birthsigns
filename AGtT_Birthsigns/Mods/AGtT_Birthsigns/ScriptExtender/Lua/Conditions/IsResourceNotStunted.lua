function Conditions.IsResourceNotStunted(resource)
  CLUtils.Info("Entering IsResourceStunted", Globals.InfoOverride)

  return resource ~= CLGlobals.ActionResources.CL_StuntedSpellSlot
end
