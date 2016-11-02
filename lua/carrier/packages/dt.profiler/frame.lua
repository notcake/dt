local self = {}
Profiler.Frame = Class (self)

function self:ctor (index, startTime)
	self.Index = index
	
	self.Section = Profiler.Section (nil, startTime)
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

function Profiler.Frame.Recycle (self, index, startTime)
	self.Index = index
	
	Profiler.Section.Recycle (self.Section, nil, startTime)
end

Profiler.Frame.Clear = self.Clear
