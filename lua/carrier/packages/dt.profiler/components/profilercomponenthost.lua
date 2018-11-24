local self = {}
Profiler.ProfilerComponentHost = Class(self)

function self:ctor()
	self.Components = {}
end

function self:dtor()
	for component in self:GetEnumerator() do
		component:Disable()
		component:dtor()
	end
end

function self:Add(name, component)
	self.Components[name] = component
end

function self:Enable(name)
	if name then
		self.Components[name]:Enable()
	else
		for component in self:GetEnumerator() do
			component:Enable()
		end
	end
end

function self:Disable(name)
	if name then
		self.Components[name]:Disable()
	else
		for component in self:GetEnumerator() do
			component:Disable()
		end
	end
end

function self:GetEnumerator()
	return ValueEnumerator(self.Components)
end
