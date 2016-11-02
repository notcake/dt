Profiler = {}

Error = Carrier.LoadPackage ("Pylon.Error")
OOP   = Carrier.LoadPackage ("Pylon.OOP")
OOP.Initialize (_ENV)

IO = {}
Carrier.LoadProvider ("Pylon.IO").Initialize (IO)

Enumeration = Carrier.LoadPackage ("Pylon.Enumeration")
Enumeration.Initialize (_ENV)

HTTP = Carrier.LoadProvider ("Pylon.HTTP")

include ("poolallocator.lua")

include ("section.lua")
include ("projectedsection.lua")
include ("frame.lua")

include ("profiler.lua")

-- Components
include ("components/profilercomponenthost.lua")
include ("components/iprofilercomponent.lua")
include ("components/profilercomponent.lua")

include ("components/frameadvancecomponent.lua")
include ("components/gamemodehookcomponent.lua")

Profiler.Profiler = Profiler.Profiler ()
ComponentHost = Profiler.ProfilerComponentHost ()
ComponentHost:Add ("FrameAdvance", Profiler.FrameAdvanceComponent (Profiler.Profiler))
ComponentHost:Add ("Gamemode",     Profiler.GamemodeHookComponent (Profiler.Profiler))

ComponentHost:Enable ()

-- include ("api.lua")

return Profiler
