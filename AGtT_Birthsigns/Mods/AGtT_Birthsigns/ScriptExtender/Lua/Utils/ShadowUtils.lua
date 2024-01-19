function Utils.HandleClearObscurity(entityId)
  CLUtils.Info("Entering HandleClearObscurity", Globals.InfoOverride)
  if Osi.HasActiveStatus(entityId, "INVISIBILITY") == 1 then
    Osi.RemoveStatus(entityId, "INVISIBILITY")
  end
end

function Utils.HandleLightObscurity(entityId)
  CLUtils.Info("Entering HandleLightObscurity", Globals.InfoOverride)
  if Osi.HasActiveStatus(entityId, "INVISIBILITY") == 1 and
    (Osi.HasActiveStatus(entityId, "SNEAKING") == 0 or Osi.HasActiveStatus(entityId, "SNEAKING_LIGHTLY_OBSCURED") == 0) then

    Osi.RemoveStatus(entityId, "INVISIBILITY")
  end

  if Osi.HasActiveStatus(entityId, "SNEAKING") == 1 and
    Osi.HasActiveStatus(entityId, "INVISIBILITY") == 0 then

    Osi.ApplyStatus(entityId, "INVISIBILITY", -1)
  end
end

function Utils.HandleHeavyObscurity(entityId)
  CLUtils.Info("Entering HandleHeavyObscurity", Globals.InfoOverride)
  if Osi.HasActiveStatus(entityId, "INVISIBILITY") == 1 then
    Osi.ApplyStatus(entityId, "INVISIBILITY", -1)
  end
end

function Utils.HandleShadowToggle(entityId, doRemove)
  CLUtils.Info("Entering HandleShadowToggle", Globals.InfoOverride)
  if doRemove then
    Osi.RemoveStatus(entityId, "INVISIBILITY")
  else
    local obscurityState = Osi.GetObscuredState(entityId)
    Utils[Globals.ObscurityMap[obscurityState]](entityId)
  end
end
