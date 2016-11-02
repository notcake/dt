local self = {}
Profiler.GamemodeHookComponent = Class (self, Profiler.ProfilerComponent)

function self:ctor (profiler)
	self.Profiler = profiler
	
	self.Gamemode = nil
	
	self.OriginalHooks     = {}
	self.InstrumentedHooks = {}
end

-- Internal, do not call
function self:OnEnabled ()
	self.Gamemode = GAMEMODE or GM
	
	for methodName, f in pairs (self.Gamemode) do
		if type (f) == "function" then
			self.OriginalHooks     [methodName] = f
			self.InstrumentedHooks [methodName] = self.Profiler:Wrap (self.OriginalHooks [methodName], "GAMEMODE:" .. methodName)
			
			self.Gamemode [methodName] = self.InstrumentedHooks [methodName]
		end
	end
end

function self:OnDisabled ()
	for methodName, f in pairs (self.Gamemode) do
		if type (f) == "function" and
		   f == self.InstrumentedHooks [methodName] then
			self.Gamemode [methodName] = self.OriginalHooks [methodName]
		end
	end
	
	self.OriginalHooks     = {}
	self.InstrumentedHooks = {}
end
