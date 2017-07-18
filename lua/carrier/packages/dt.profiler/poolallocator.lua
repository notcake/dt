local self = {}
Profiler.PoolAllocator = Class (self)

function self:ctor (class)
	self.Class = class
	
	self.TotalSize = 0
	self.Pool = {}
end

function self:Alloc (...)
	if #self.Pool > 0 then
		local object = self.Pool [#self.Pool]
		self.Pool [#self.Pool] = nil
		
		object:Initialize (...)
		
		return object
	else
		local object = self.Class (self)
		
		self.TotalSize = self.TotalSize + 1
		
		object:Initialize (...)
		
		return object
	end
end

function self:Free (object)
	object:Scrub ()
	
	self.Pool [#self.Pool + 1] = object
end

function self:GetAvailableCount ()
	return #self.Pool
end

function self:GetTotalSize ()
	return self.TotalSize
end
