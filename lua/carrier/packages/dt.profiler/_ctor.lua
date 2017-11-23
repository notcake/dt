-- PACKAGE dt.Profiler

Profiler = {}

Error = require ("Pylon.Error")
OOP   = require ("Pylon.OOP")
OOP.Initialize (_ENV)

IO = {}
require_provider ("Pylon.IO").Initialize (IO)

Enumeration = require ("Pylon.Enumeration")
Enumeration.Initialize (_ENV)

CircularBuffer = require ("Pylon.Containers.CircularBuffer")

HTTP = require_provider ("Pylon.HTTP")

Pool = require ("Pylon.Pool")

include ("poolobject.lua")

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

ComponentHost:Enable ("FrameAdvance")

-- include ("api.lua")

return Profiler
