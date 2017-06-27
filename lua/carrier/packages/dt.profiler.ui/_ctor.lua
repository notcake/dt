UI = {}

Error = require ("Pylon.Error")
OOP   = require ("Pylon.OOP")
OOP.Initialize (_ENV)

Util  = require ("Pylon.Util")

Profiler = require ("dt.Profiler")

include ("frame.lua")
include ("commands.lua")

Frame = UI.Frame (Profiler.Profiler)

RegisterCommands ()

return UI
