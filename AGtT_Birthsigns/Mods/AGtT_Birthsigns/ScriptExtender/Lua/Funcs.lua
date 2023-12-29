Ext.Require("InitGlobals.lua")

local function LoadSpellSlotsGroup()
  CLUtils.Info("Entering LoadSpellSlotsGroup", true)
  for _, resource in pairs(Ext.StaticData.Get(CLGlobals.ActionResourceGroups.SpellSlotsGroup, "ActionResourceGroup").ActionResourceDefinitions) do
    if resource ~= CLGlobals.ActionResources.CL_StuntedSpellSlot then
      CLUtils.AddToTable(Globals.ValidSlots, resource)
    end
  end
end

local function ModifyStuntedSlotsBySpell(entity, spell, amount)
  CLUtils.Info("Entering ModifyStuntedSlotsBySpell", true)
  local spellData = Ext.Stats.Get(spell)
  local level = spellData.Level or 1

  if spellData.SpellFlags then
    CLUtils.ModifyResourceAmount(entity, "CL_StuntedSpellSlot", amount, level)
  end
end

-- Cast Spell = reduce Stunted Slots
Ext.Osiris.RegisterListener("CastSpell", 5, "after", function (char, spell, _, _, _)
  if Utils.ModifySlotConditions(char, spell) then
    ModifyStuntedSlotsBySpell(char, spell, -1)
  end
end)

-- Damaged by Spell = increase Stunted Slots at Spell Level X
Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function (_, target, spell, _, _, _)
  if Utils.ModifySlotConditions(target, spell) then
    ModifyStuntedSlotsBySpell(target, spell, 1)
  end
end)

local function RemoveUnStuntedSlots(resources)
  CLUtils.Info("Entering RemoveUnStuntedSlots", true)
  for _, resourceUUID in pairs(Globals.ValidSlots) do
    resources[resourceUUID] = nil
  end
end

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function (levelName, isEditorMode)
  for _, player in pairs(Osi.DB_Players:Get(nil)) do
    if CLUtils.EntityHasPassive(player[1], Globals.AtronachPassive) then
      table.insert(Globals.Characters, { UUID = player, amount = 0 })
    end
  end

  -- Add Stunted Slots based on Existing Spell Slots, remove old ones
  -- This seems to be undone when loading a save...
  Ext.Entity.Subscribe("ActionResources", function (entity, component, _)
    if entity.Uuid and Utils.RetrieveCharacter(entity.Uuid.EntityUuid) then
      CLUtils.Info("Subscribed to Action Resources on entity " .. entity.Uuid.EntityUuid, true)
      local resources = entity.ActionResources.Resources
      local slotTable = Utils.RetrieveSlotData(resources)

      for _, slotObj in pairs(slotTable) do
        CLUtils.ModifyResourceAmount(
          entity.Uuid.EntityUuid,
          CLGlobals.ActionResources.CL_StuntedSpellSlot,
          slotObj.Level,
          slotObj.Amount)
      end

      RemoveUnStuntedSlots(resources)
    end
  end)
end)

local function OnSessionLoaded()
  LoadSpellSlotsGroup()
end

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
