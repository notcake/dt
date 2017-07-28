local self = {}
Profiler.Section = Class (self, Profiler.PoolObject)

function self:ctor (pool)
	self.Children  = {}
end

-- PoolObject
function self:Initialize (name, startTime)
	self.Name      = name
	
	self.StartTime = startTime
	self.EndTime   = nil
end

function self:Scrub ()
	for i = #self.Children, 1, -1 do
		local section = self.Children [i]
		self.Children [i] = nil
		section:Free ()
	end
end

-- Section
function self:Clear ()
	for i = #self.Children, 1, -1 do
		self.Children [i] = nil
	end
end

function self:End (t)
	self.EndTime = t
end

function self:GetName ()
	return self.Name
end

function self:GetStartTime ()
	return self.StartTime
end

function self:GetEndTime ()
	return self.EndTime
end

function self:GetDuration ()
	return self.EndTime - self.StartTime
end

function self:AddChild (section)
	self.Children [#self.Children + 1] = section
end

function self:GetChild (index)
	return self.Children [index]
end

function self:GetChildCount ()
	return #self.Children
end

function self:GetChildEnumerator ()
	return ArrayEnumerator (self.Children)
end

function self:IndexOf (name)
	for i = 1, #self.Children do
		if self.Children [i]:GetName () == name then
			return self.Children [i]
		end
	end
	
	return nil
end

Profiler.Section.Pool = Pool (Profiler.Section, self.Initialize, self.Scrub)
function Profiler.Section.Alloc (...)
	return Profiler.Section.Pool:Alloc (...)
end
