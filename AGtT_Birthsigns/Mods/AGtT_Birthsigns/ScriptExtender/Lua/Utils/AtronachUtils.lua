--- Modify amounts from a given resource into Stunted Slots, and set the original Resource amounts to Zero.
--- @param entity userdata SE Entity object
--- @param baseResource table Table containing Amount, Level, and UUID
function Utils.TransferResource(entity, baseResource)
  CLUtils.Info("Entering TransferResource", Globals.InfoOverride)
  local currentBaseSlots = CLUtils.GetResourceAtLevel(entity, baseResource.Name, baseResource.Level) or 0
  local currentStuntedSlots = CLUtils.GetResourceAtLevel(entity, "CL_StuntedSpellSlot", baseResource.Level) or 0
  local baseAmountToIgnore = 0

  if currentBaseSlots > 0 then
    baseAmountToIgnore = Utils.GetValue(entity.Uuid.EntityUuid, baseResource.Name, baseResource.Level, "PrevAmount")
  end

  local delta = currentBaseSlots - baseAmountToIgnore

  _P(
    "For level " .. baseResource.Level ..
    ": OG Resource amount: " .. baseResource.Amount ..
    ", OG Amount based on GetResourceAtLevel: " .. currentBaseSlots ..
    ", Current Stunted Slots: " .. currentStuntedSlots ..
    ", Amount to Ignore: " .. baseAmountToIgnore ..
    ", Amount to add: " .. delta
  )

  -- Add Slots to StuntedSlots
  if delta > 0 then
    CLUtils.Info("Modifying Entity Resource Value for CL_StuntedSpellSlot (" .. currentStuntedSlots .. ") by " .. delta,
      true)
    Utils.AddResourceBoosts(entity, "CL_StuntedSpellSlot", delta, baseResource.Level)
    Utils.SetValue(entity.Uuid.EntityUuid, "CL_StuntedSpellSlot", baseResource.Level, "Amount",
      CLUtils.GetResourceAtLevel(entity, "CL_StuntedSpellSlot", baseResource.Level))
    Utils.SetValue(entity.Uuid.EntityUuid, "CL_StuntedSpellSlot", baseResource.Level, "PrevAmount", currentStuntedSlots)
  end

  -- Remove Slots
  if currentBaseSlots ~= 0 then
    --Utils.AddResourceBoosts(entity, baseResource.Name, 0, baseResource.Level, true)
    CLUtils.SetEntityResourceValue(
      entity,
      baseResource.UUID,
      { Amount = 0, MaxAmount = 0 },
      baseResource.Level
    )
    Utils.SetValue(entity.Uuid.EntityUuid, baseResource.Name, baseResource.Level, "Amount", 0)
    Utils.SetValue(entity.Uuid.EntityUuid, baseResource.Name, baseResource.Level, "PrevAmount", currentBaseSlots)
  end

  _D(Globals.CharacterResources[entity.Uuid.EntityUuid])
end

--- Add an amount of resources to an entity based on a given resource level.
--- @param entity userdata Entity to add the resource to.
--- @param name string Name of the desired Action Resource.
--- @param amount? number The amount of the resource you want to add. Defaults to 1.
--- @param level? number The Level at which you want the resource to be added. Defaults to 0.
--- @param override? boolean True if ActionResourceOverride, false if ActionResource.
function Utils.AddResourceBoosts(entity, name, amount, level, override)
  level = level or 0
  amount = amount or 1
  local boost = "ActionResource"

  if override then
    boost = "ActionResourceOverride"
  end
  Osi.AddBoosts(entity.Uuid.EntityUuid, boost .. "(" .. name .. "," .. amount .. "," .. level .. ")", "", "")

  entity:Replicate("BoostsContainer")
  entity:Replicate("ActionResources")
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
      "CL_StuntedSpellSlot",
      { Amount = amount, MaxAmount = amount },
      level
    )
  end
  Utils.SetValue(entity.Uuid.EntityUuid, "CL_StuntedSpellSlot", level, "Amount",
    CLUtils.GetResourceAtLevel(entity, "CL_StuntedSpellSlot", level))
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
