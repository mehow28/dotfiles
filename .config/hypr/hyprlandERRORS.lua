-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  ◈ HYPRLAND LUA CONFIGURATION
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--
--  Created by ilyamiro
--  https://github.com/ilyamiro/nixos-configuration
--
--  Migrated from hyprland.conf to hyprland.lua
--

-- ─────────────────────────────────────────────────────────
--  Module Loading
-- ─────────────────────────────────────────────────────────
require("lua.colors")
require("lua.monitors")
local vars    = require("lua.variables")
local mainMod = vars.mainMod

require("lua.env")
require("lua.autostart")
require("lua.settings")
require("lua.animations")
require("lua.rules")
require("lua.keybindings")

-- ─────────────────────────────────────────────────────────
--  Passthru submap for Quickshell
-- ─────────────────────────────────────────────────────────
hl.submap("passthru")
hl.bind(mainMod .. " + SHIFT + CTRL + ALT + F35", hl.dsp.exec_cmd("true"))
hl.submap("reset")
