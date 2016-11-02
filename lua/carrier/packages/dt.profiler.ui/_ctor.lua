UI = {}

Error = Carrier.LoadPackage ("Pylon.Error")
OOP   = Carrier.LoadPackage ("Pylon.OOP")
OOP.Initialize (_ENV)

Util  = Carrier.LoadPackage ("Pylon.Util")

Profiler = Carrier.LoadPackage ("dt.Profiler")

include ("frame.lua")

Frame = UI.Frame (Profiler.Profiler)

return UI
