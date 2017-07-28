local self = {}
CallTreeTableView = Class (self, Glass.TreeTableView)

function self:ctor (profiler)
	self.Profiler = profiler
	self.Frame    = nil
end

-- CallTreeTableView
function self:GetProfiler ()
	return self.Profiler
end

function self:SetFrame (frame)
	if self.Frame == frame then return end
	
	local previousFrame = self.Frame
	self.Frame = frame
	
	self:ClearItems ()
	self:AddItem ()
	for section in self.Frame:GetChildEnumerator () do
		self:AddItem ()
	end
end
