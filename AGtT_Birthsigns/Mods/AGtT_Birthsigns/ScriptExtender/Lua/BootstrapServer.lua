Ext.Require("InitGlobals.lua")
Ext.Require("Conditions/_init.lua")
Ext.Require("Actions/_init.lua")

-- Apprentice

Ext.Osiris.RegisterListener("CastedSpell", 5, "after", function (caster, spell, _, _, _)
  Actions.OnCast(caster, spell)
end)

-- Atronach

--- Damaged by Spell = increase Stunted Slots at Spell Level X.
Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function (_, target, spell, _, _, _)
  Actions.OnHostileSpell(target, spell)
end)

--- Listener for Level-Up to apply new Atronach Spell Slot at valid levels
Ext.Osiris.RegisterListener("LeveledUp", 1, "after", function (character)
  Actions.OnLevelUp(character)
end)

--- Listener for Respec to remove Atronach Slots. TODO: This doesn't work as expected
Ext.Osiris.RegisterListener("RespecCompleted", 1, "after", function (character)
  Actions.OnRespec(character)
end)

--- Add Stunted Slots based on Existing Spell Slots, remove old ones.
Ext.Entity.Subscribe("ActionResources", function (entity, _, _)
  if not Globals.SyncingSlots then Actions.OnResourceChanged(entity) end
end)

Ext.Events.SessionLoading:Subscribe(Actions.OnSessionLoading)

Ext.Events.SessionLoaded:Subscribe(Actions.OnSessionLoaded)
Ext.Events.ResetCompleted:Subscribe(Actions.OnSessionLoaded)

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function (_, _)
  Actions.OnLevelGameplayStarted()
end)

-- Shadow

-- Apply Invisibility when Obscured
Ext.Osiris.RegisterListener("ObscuredStateChanged", 2, "after", function (object, obscuredState)
  Actions.OnObscurityChanged(object, obscuredState)
end)

-- Making sure we're undoing or applying Invisibility based on Obscurity when toggling passive on or off
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function (object, status, _, _)
  Actions.OnStatusApplied(object, status)
end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function (object, status, _, _)
  Actions.OnStatusRemoved(object, status)
end)
