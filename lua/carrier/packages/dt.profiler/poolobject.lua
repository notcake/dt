local self = {}
Profiler.PoolObject = Class (self)

function self:ctor (pool)
	self.Allocator = pool
end

function self:Free ()
	self.Allocator:Free (self)
end

function self:Initialize (...)
end

function self:Scrub ()
end
