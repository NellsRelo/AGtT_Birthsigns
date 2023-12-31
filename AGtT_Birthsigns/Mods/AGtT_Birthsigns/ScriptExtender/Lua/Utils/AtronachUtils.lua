--- Returns 1 if the Action Resource needs to be manually created via Boost, 0 if not.
--- @param entity userdata
--- @param level number
---@return integer res 1 if Stunted Spell Slot needs to be manually created, 0 if not.
function Utils.PrepareStuntedResource(entity, level)
  CLUtils.Info("Entering PrepareStuntedResource")
  local res = 0
  local found = false
  local resourceData = CLUtils.GetActionResourceData(entity, "CL_StuntedSpellSlot")

  if resourceData then
    for _, resourceObj in pairs(resourceData) do
      if CLUtils.ToInteger(resourceObj.ResourceId) == CLUtils.ToInteger(level) then
        found = true
      end
    end
  end

  if not found then
    Osi.AddBoosts(entity.Uuid.EntityUuid, "ActionResources(CL_StuntedSpellSlot,1," .. level .. ")", "", "")
    res = 1
  end

  return res
end

--- Modify amounts from a given resource into Stunted Slots, and set the original Resource amounts to Zero.
--- @param entity userdata SE Entity object
--- @param baseResource table Table containing Amount, Level, and UUID
function Utils.TransferSlotsToStunted(entity, baseResource)
  CLUtils.Info("Entering TransferSlotsToStunted", Globals.InfoOverride)
  local preparationResult = Utils.PrepareStuntedResource(entity, baseResource.Level)
  local currentBaseSlots = CLUtils.GetResourceAtLevel(entity, baseResource.Name, baseResource.Level) or 0
  local currentStuntedSlots = CLUtils.GetResourceAtLevel(entity, "CL_StuntedSpellSlot", baseResource.Level) or 0
  local baseAmountToIgnore = 0
  if currentBaseSlots ~= 0 then
    baseAmountToIgnore = Utils.GetPreviousAmount(entity.Uuid.EntityUuid, baseResource.Name,
      baseResource.Level)
  end
  local delta = currentBaseSlots - baseAmountToIgnore
  _P(
    "For level " .. baseResource.Level ..
    ": OG Resource amount: " .. baseResource.Amount ..
    ", OG Amount based on GetResourceAtLevel: " .. currentBaseSlots ..
    ", Current Stunted Slots: " .. currentStuntedSlots ..
    ", Amount Prepared: " .. preparationResult ..
    ", Amount to Ignore: " .. baseAmountToIgnore ..
    ", Amount to add: " .. delta
  )

  -- Modify Stunted Slots
  if delta > 0 then
    CLUtils.Info("Modifying Entity Resource Value for CL_StuntedSpellSlot (" .. currentStuntedSlots .. ")by " .. delta, true)
    _D(entity.ActionResources.Resources[CLGlobals.ActionResources.CL_StuntedSpellSlot])
    CLUtils.ModifyEntityResourceValue(
      entity,
      CLGlobals.ActionResources.CL_StuntedSpellSlot,
      { Amount = delta, MaxAmount = delta },
      baseResource.Level
    )
    Utils.RegisterSlot(
      entity.Uuid.EntityUuid,
      "CL_StuntedSpellSlot",
      baseResource.Level,
      CLUtils.GetResourceAtLevel(entity, "CL_StuntedSpellSlot", baseResource.Level),
      currentStuntedSlots
    )
  end
  -- Remove Base Slots
  if currentBaseSlots ~= 0 then
    CLUtils.SetEntityResourceValue(
      entity,
      baseResource.UUID,
      { Amount = 0, MaxAmount = 0 },
      baseResource.Level
    )

    Utils.RegisterSlot(
      entity.Uuid.EntityUuid,
      baseResource.Name,
      baseResource.Level,
      0,
      currentBaseSlots
    )
  end
end

--- Modify Stunted Slots when hit with a Spell
--- @param entity userdata
--- @param spell string
--- @param amount number
function Utils.ModifyStuntedSlotsBySpell(entity, spell, amount)
  CLUtils.Info("Entering ModifyStuntedSlotsBySpell", Globals.InfoOverride)
  local spellData = Ext.Stats.Get(spell)
  local level = spellData.Level or 1

  if spellData.SpellFlags then
    CLUtils.ModifyEntityResourceValue(
      entity,
      CLGlobals.ActionResources.CL_StuntedSpellSlot,
      { Amount = amount, MaxAmount = amount },
      level
    )
  end

  Utils.RegisterSlot(
    entity.Uuid.EntityUuid,
    "CL_StuntedSpellSlot",
    level,
    CLUtils.GetResourceAtLevel(entity, "CL_StuntedSpellSlot", level) or 0
  )
end

--- Set Action Resources based on ModVars when loading a session
--- @param entity userdata
--- @param resources table
function Utils.SyncSlotValuesOnSession(entity, resources)
  for resourceName, resourcesAtLevel in pairs(resources) do
    for resourceLevel, resourceAmount in pairs(resourcesAtLevel) do
      CLUtils.SetEntityResourceValue(
        entity,
        CLGlobals.ActionResources[resourceName],
        { Amount = resourceAmount, MaxAmount = resourceAmount },
        resourceLevel
      )
    end
  end
end
