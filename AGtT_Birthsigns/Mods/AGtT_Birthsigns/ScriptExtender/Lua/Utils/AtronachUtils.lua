--- Modify amounts from a given resource into Stunted Slots, and set the original Resource amounts to Zero.
--- @param entity userdata SE Entity object
--- @param baseResource table Table containing Amount, Level, and UUID
function Utils.TransferResource(entity, baseResource)
  CLUtils.Info("Entering TransferResource", Globals.InfoOverride)
  local currentBaseSlots = CLUtils.GetResourceAtLevel(entity, baseResource.Name, baseResource.Level) or 0
  local currentStuntedSlots = CLUtils.GetResourceAtLevel(entity, "CL_StuntedSpellSlot", baseResource.Level) or 0
  local baseAmountToIgnore = 0

  if baseResource.Amount > 0 then
    baseAmountToIgnore = Utils.GetValue(entity.Uuid.EntityUuid, baseResource.Name, baseResource.Level, "PrevAmount")
  end

  local delta = currentBaseSlots - baseAmountToIgnore
  local newCurrentStuntedSlots = currentStuntedSlots + delta

  -- Add Slots to StuntedSlots
  if delta > 0 then
    Utils.IncrementStuntedSlots(entity, currentStuntedSlots, newCurrentStuntedSlots, baseResource.Level)
  end

  -- Remove Slots
  if currentBaseSlots ~= 0 then
    CLUtils.SetEntityResourceValue(
      entity,
      baseResource.UUID,
      { Amount = 0, MaxAmount = 0 },
      baseResource.Level
    )
    Utils.SetValue(entity.Uuid.EntityUuid, baseResource.Name, baseResource.Level, "Amount", 0)
    Utils.SetValue(entity.Uuid.EntityUuid, baseResource.Name, baseResource.Level, "PrevAmount", currentBaseSlots)
  end

  entity:Replicate("ActionResources")
end

function Utils.IncrementStuntedSlots(entity, oldAmount, newAmount, level)
  CLUtils.Info("Entering IncrementStuntedSlots", Globals.InfoOverride)
  Osi.RemoveBoosts(entity.Uuid.EntityUuid,
    "ActionResourceOverride(CL_StuntedSpellSlot," .. oldAmount .. "," .. level .. ")", 1, "", "")
  entity:Replicate("BoostsContainer")
  entity:Replicate("ActionResources")
  Utils.AddResourceBoosts(entity, "CL_StuntedSpellSlot", newAmount, level, true)
  Utils.SetValue(entity.Uuid.EntityUuid, "CL_StuntedSpellSlot", level, "Amount", newAmount)
  Utils.SetValue(entity.Uuid.EntityUuid, "CL_StuntedSpellSlot", level, "PrevAmount", oldAmount)
end

function Utils.RemoveStuntedSlots(entity)
  CLUtils.Info("Entering RemoveStuntedSlots", Globals.InfoOverride)
  local slotsToRemove = CLUtils.FilterEntityResources(Globals.ValidSlots, entity.ActionResources.Resources)
  for _, slotObj in pairs(slotsToRemove) do
    if slotObj.Name == "CL_StuntedSpellSlot" then
      Utils.IncrementStuntedSlots(entity, slotObj.Amount, 0, slotObj.Level)
    end
  end
  Utils.IncrementStuntedSlots(entity, 0, 1, 1)
end

--- Add an amount of resources to an entity based on a given resource level.
--- @param entity userdata Entity to add the resource to.
--- @param name string Name of the desired Action Resource.
--- @param amount? number The amount of the resource you want to add. Defaults to 1.
--- @param level? number The Level at which you want the resource to be added. Defaults to 0.
--- @param override? boolean True if ActionResourceOverride, false if ActionResource.
function Utils.AddResourceBoosts(entity, name, amount, level, override)
  CLUtils.Info("Entering AddResourceBoosts", Globals.InfoOverride)
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
  local currentStuntedSlots = CLUtils.GetResourceAtLevel(entity, "CL_StuntedSpellSlot", level) or 0
  if spellData.SpellFlags then
    Utils.IncrementStuntedSlots(entity, currentStuntedSlots, currentStuntedSlots + amount, level)
  end
end

--- Remove Spell Slots from entities that should have them on load
--- @param entity userdata entity to remove from
function Utils.NullifySpellSlots(entity)
  CLUtils.Info("Entering NullifySpellSlots", Globals.InfoOverride)
  local slotTable = CLUtils.FilterEntityResources(Globals.ValidSlots, entity.ActionResources.Resources)
  for _, slotObj in pairs(slotTable) do
    if slotObj.Name ~= "CL_StuntedSpellSlot" then
      CLUtils.SetEntityResourceValue(
        entity,
        slotObj.UUID,
        { Amount = 0, MaxAmount = 0 },
        slotObj.Level
      )
    end
  end
end
