--- Check if Entity that had its obscurity changed is a Shadow Player with Moonshadow
--- Passive. If so, and Obscurity is not clear, apply Invisibility. Otherwise,
--- remove Invisibility.
--- @param entityId string ID of entity who's obscurity has changed.
---@param obscurityState string String representation of Obscurity. `Clear`, `LightlyObscured`, or `HeavilyObscured`
function Actions.OnObscurityChanged(entityId, obscurityState)
  CLUtils.Info("Entering OnObscurityChanged", Globals.InfoOverride)
  local entity = Ext.Entity.Get(entityId)
  if Conditions.IsMoonshadowPlayer(entity) and Conditions.IsMoonshadowActive(entity) then
    Utils[Globals.ObscurityMap[obscurityState]](entityId)
  end
end
