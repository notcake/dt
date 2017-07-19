UI = {}

Error = require ("Pylon.Error")
OOP   = require ("Pylon.OOP")
OOP.Initialize (_ENV)

Color = require ("Pylon.Color")

Util  = require ("Pylon.Util")

Profiler = require ("dt.Profiler")

Phoenix = require_provider ("Phoenix")

include ("frametimegraph.lua")
include ("frametimegraph.graph.lua")
include ("calltreetableview.lua")
include ("window.lua")

include ("commands.lua")

Window = nil
function GetWindow ()
	Window = Window or UI.Window (Profiler.Profiler)
	return Window
end

RegisterCommands ()

return UI
