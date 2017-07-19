local self = {}
CallTreeTableView = Class (self, Glass.TreeTableView)

function self:ctor (profiler)
	self.Profiler = profiler
end

-- CallTreeTableView
function self:GetProfiler ()
	return self.Profiler
end
