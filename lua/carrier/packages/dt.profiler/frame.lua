local self = {}
Profiler.Frame = Class (self, Profiler.PoolObject)

function self:ctor (pool)
end

-- PoolObject
function self:Initialize (index, startTime)
	self.RefCount = 1
	
	self.Index = index
	
	self.Section = Profiler.Section.Alloc (nil, startTime)
end

function self:Scrub ()
	self.Section:Free ()
	self.Section = nil
end

-- Frame
function self:AddRef ()
	self.RefCount = self.RefCount + 1
end

function self:Release ()
	self.RefCount = self.RefCount - 1
	if self.RefCount == 0 then
		self:Free ()
	end
end

function self:Clear ()
	self.Section:Clear ()
end

function self:End (t)
	self.Section:End (t)
end

function self:GetIndex () return self.Index end

function self:GetStartTime () return self.Section:GetStartTime () end
function self:GetEndTime   () return self.Section:GetEndTime   () end

function self:GetDuration  () return self.Section:GetDuration  () end

function self:GetRootSection ()
	return self.Section
end

Profiler.Frame.Pool = Profiler.PoolAllocator (Profiler.Frame)
function Profiler.Frame.Alloc (...)
	return Profiler.Frame.Pool:Alloc (...)
end
