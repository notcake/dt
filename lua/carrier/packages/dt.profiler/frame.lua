local self = {}
Profiler.Frame = Class(self, Profiler.PoolObject)

function self:ctor(pool)
end

-- PoolObject
function self:Initialize(index, startTime)
	self.RefCount = 1
	
	self.Index = index
	
	self.Section = Profiler.Section.Alloc(string.format("Frame %d", index), startTime)
end

function self:Scrub()
	self.Section:Free()
	self.Section = nil
end

-- Frame
function self:AddRef()
	self.RefCount = self.RefCount + 1
end

function self:Release()
	self.RefCount = self.RefCount - 1
	if self.RefCount == 0 then
		self:Free()
	end
end

function self:Clear()
	self.Section:Clear()
end

function self:End(t)
	self.Section:End(t)
end

function self:GetIndex()
	return self.Index
end

function self:GetRootSection()
	return self.Section
end

-- Section
function self:GetName()
	return self.Section:GetName()
end

function self:GetStartTime()
	return self.Section:GetStartTime()
end

function self:GetEndTime()
	return self.Section:GetEndTime()
end

function self:GetDuration()
	return self.Section:GetDuration()
end

function self:GetChild(index)
	return self.Section:GetChild(index)
end

function self:GetChildCount()
	return self.Section:GetChildCount()
end

function self:GetChildEnumerator()
	return self.Section:GetChildEnumerator()
end

Profiler.Frame.Pool = Pool(Profiler.Frame, self.Initialize, self.Scrub)
function Profiler.Frame.Alloc(...)
	return Profiler.Frame.Pool:Alloc(...)
end
