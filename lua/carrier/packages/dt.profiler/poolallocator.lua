local self = {}
Profiler.PoolAllocator = Class (self)

function self:ctor (factory, recycler, scrubber)
	self.Factory  = factory
	self.Recycler = recycler
	self.Scrubber = scrubber
	
	self.TotalSize = 0
	self.Pool = {}
end

self.Factory  = Property ()
self.Recycler = Property ()
self.Scrubber = Property ()

function self:Alloc (...)
	if #self.Pool > 0 then
		local object = self.Pool [#self.Pool]
		self.Pool [#self.Pool] = nil
		
		if self.Recycler then
			self.Recycler (object, ...)
		end
		
		return object
	else
		local object = self.Factory (...)
		
		self.TotalSize = self.TotalSize + 1
		
		return object
	end
end

function self:Free (object)
	if self.Scrubber then
		self.Scrubber (object)
	end
	
	self.Pool [#self.Pool + 1] = object
end

function self:GetAvailableCount ()
	return #self.Pool
end

function self:GetTotalSize ()
	return self.TotalSize
end
