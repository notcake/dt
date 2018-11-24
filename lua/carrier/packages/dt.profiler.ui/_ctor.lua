-- PACKAGE dt.Profiler.UI

UI = {}

Error = require("Pylon.Error")
OOP   = require("Pylon.OOP")
OOP.Initialize(_ENV)

Color = require("Pylon.Color")

Util  = require("Pylon.Util")

Profiler = require("dt.Profiler")

Glass = require_provider("Glass")

include("frametimegraph.lua")
include("frametimegraph.graph.lua")
include("calltreetableview.lua")
include("window.lua")

include("commands.lua")

Window = nil
function GetWindow()
	if not Window then
		collectgarbage("stop")
		debug.sethook()
		local t0 = SysTime()
		Window = UI.Window(Profiler.Profiler)
		print("\tdt.Profiler.UI.Window() took " .. GLib.FormatDuration(SysTime() - t0))
		local t1 = SysTime()
		Window:SetParent(Glass.Environment:GetRootView())
		print("\tdt.Profiler.UI.Window reification took " .. GLib.FormatDuration(SysTime() - t1))
		Window:Center()
		print("dt.Profiler.UI.Window() took " .. GLib.FormatDuration(SysTime() - t0))
		collectgarbage("restart")
	end
	
	return Window
end

RegisterCommands()

return UI
