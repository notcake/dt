_G.Profiler = {}

function _G.Profiler:Begin (name)
	return Profiler.Profiler:BeginSection (name)
end

function _G.Profiler:End ()
	return Profiler.Profiler:EndSection (name)
end
