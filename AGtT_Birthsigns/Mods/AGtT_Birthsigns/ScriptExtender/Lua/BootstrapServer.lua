Ext.Require("InitGlobals.lua")
Ext.Require("Conditions/_init.lua")
Ext.Require("Actions/_init.lua")

-- Damaged by Spell = increase Stunted Slots at Spell Level X. TODO: Confirm this bypasses Override Boost
Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function (_, target, spell, _, _, _)
  Actions.OnHostileSpell(target, spell)
end)

-- Listener for Level-Up to apply new Atronach Spell Slot at valid levels
Ext.Osiris.RegisterListener("LeveledUp", 1, "after", function (character)
  Actions.OnLevelUp(character)
end)

-- Listener for Respec to remove Atronach Slots
Ext.Osiris.RegisterListener("RespecCompleted", 1, "after", function (character)
  Actions.OnRespec(character)
end)

-- Add Stunted Slots based on Existing Spell Slots, remove old ones.
Ext.Entity.Subscribe("ActionResources", function (entity, _, _)
  if not Globals.SyncingSlots then Actions.OnResourceChanged(entity) end
end)

Ext.Events.SessionLoading:Subscribe(Actions.OnSessionLoading)

Ext.Events.SessionLoaded:Subscribe(Actions.OnSessionLoaded)
Ext.Events.ResetCompleted:Subscribe(Actions.OnSessionLoaded)
