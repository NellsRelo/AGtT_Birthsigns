--- Check if Entity who has levelled up is a valid Atronach Player, then increment
--- their Level 1 Stunted Spell Slots by 1.
--- @param entity entity who has just levelled up.
function Actions.OnLevelUp(entity)
  CLUtils.Info("Entering OnLevelUp", Globals.InfoOverride)
  if Conditions.IsAtronachPlayer(entity) then
    local currentStuntedSlots = CLUtils.GetResourceAtLevel(entity.Uuid.EntityUuid, "CL_StuntedSpellSlot", 1) or 0
    Utils.IncrementStuntedSlots(entity, currentStuntedSlots, currentStuntedSlots + 1, 1)
  end
end
