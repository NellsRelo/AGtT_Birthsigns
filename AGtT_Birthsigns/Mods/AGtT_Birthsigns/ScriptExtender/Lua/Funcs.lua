Ext.Require("InitGlobals.lua")

local function ModifyStuntedSlotsBySpell(entity, spell, amount)
  local spellData = Ext.Stats.Get(spell)
  local level = spellData.level or 1

  Utils.ModifySlotAmount(entity, Globals.StuntedSlotId, amount, level)
end

-- Cast Spell = reduce Max Amount of Stunted Slots
Ext.Osiris.RegisterListener("CastSpell", 5, "after", function (char, spell, _, _, _)
  if Utils.ModifySlotConditions(char, spell) then
    ModifyStuntedSlotsBySpell(char, spell, -1)
  end
end)

-- Damaged by Spell = increase Max Amount of Stunted Slots at Spell Level X
Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function (_, target, spell, _, _, _)
  if Utils.ModifySlotConditions(target, spell) then
    ModifyStuntedSlotsBySpell(target, spell, 1)
  end
end)

-- Add Stunted Slots based on Existing Spell Slots, remove old ones



local function SwapSpellSlots(entity)
  local currentAmount = 0
  for name, resourceId in pairs(Globals.ValidSlots) do
    local resourceTable = CLUtils.GetActionResourceData(entity, resourceId)
    if resourceTable then
      currentAmount = currentAmount + resourceTable.Amount
      resourceTable = nil
    end
  end

  local fleshedEntity = Ext.Entity.Get(entity)
  -- This might not work if it doesn't exist... Good thing we're giving Atronachs Stunted Spell Slots anyway!
  Osi.PartyIncreaseActionResourceValue(entity, "CL_StuntedSpellSlot", currentAmount)
end

local function OnCharactersChange()
  Globals.Characters = Osi.DB_Players:Get(nil)
end

local function onCharacterCreationFinished()

end

local function OnLevelUpFinished()

end

---@param object Guid
local function OnAddedToTeam(object)
  --Do something when object becomes a party member
end

-- Scenarios where Spell Slots can Change
--[[
  - Arcane Cultivation Elixir
  - Equipment
  - Level-up complete
  - Character Creation
  - Rest/Angelic Slumber
  - ???
]]
