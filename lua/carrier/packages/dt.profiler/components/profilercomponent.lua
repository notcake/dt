local self = {}
Profiler.ProfilerComponent = Class (self, Profiler.IProfilerComponent)

function self:ctor ()
	self.Enabled = false
end

function self:dtor ()
	self:Disable ()
end

function self:IsEnabled ()
	return self.Enabled
end

function self:Enable ()
	if self.Enabled then return end
	
	self.Enabled = true
	
	self:OnEnabled ()
end

function self:Disable ()
	if not self.Enabled then return end
	
	self.Enabled = false
	
	self:OnDisabled ()
end

-- Internal, do not call
function self:OnEnabled ()
end

function self:OnDisabled ()
end
