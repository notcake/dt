local self = {}
Profiler.IProfilerComponent = Class (self)

function self:ctor ()
end

function self:IsEnabled ()
	Error ("IProfilerComponent:IsEnabled : Not implemented.")
end

function self:Enable ()
	Error ("IProfilerComponent:Enable : Not implemented.")
end

function self:Disable ()
	Error ("IProfilerComponent:Disable : Not implemented.")
end
