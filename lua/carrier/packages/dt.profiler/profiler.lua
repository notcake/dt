local self = {}
Profiler.Profiler = Class (self)

function self:ctor ()
	self.FrameAllocator = Profiler.PoolAllocator (
		Profiler.Frame,
		Profiler.Frame.Recycle,
		function (frame)
			self:ScrubFrame (frame)
		end
	)
	self.SectionAllocator = Profiler.PoolAllocator (
		Profiler.Section,
		Profiler.Section.Recycle,
		function (section)
			self:ScrubSection (section)
		end
	)
	
	self.Frames = CircularBuffer (128)
	self.CurrentFrame = nil
	self.SectionStack = {}
end

self.FrameEnded = Event ():SetName ("FrameEnded")

function self:BeginFrame (index, t)
	local t = t or SysTime ()
	
	if self.CurrentFrame then
		self:EndFrame (t)
	end
	
	self.CurrentFrame = self.FrameAllocator:Alloc (index, t)
	self.SectionStack [1] = self.CurrentFrame:GetRootSection ()
end

function self:EndFrame (t)
	local t = t or SysTime ()
	
	local currentFrame = self.CurrentFrame
	if currentFrame == nil then return end
	
	self.CurrentFrame = nil
	
	self:EndSection (2, t)
	self.SectionStack [1] = nil
	
	currentFrame:End (t)
	
	if self.Frames:GetCount () == self.Frames:GetCapacity () then
		self.FrameAllocator:Free (self.Frames:Pop ())
	end
	self.Frames:Push (currentFrame)
	
	self.FrameEnded:Dispatch (currentFrame)
end

function self:AdvanceFrame (index, t)
	local t = t or SysTime ()
	
	self:EndFrame (t)
	self:BeginFrame (index, t)
end

function self:GetCurrentFrame ()
	return self.CurrentFrame
end

function self:GetFrames ()
	return self.Frames
end

function self:BeginSection (name, t)
	if not self.CurrentFrame then
		self:BeginFrame (0)
	end

	local t = t or SysTime ()
	
	local section = self.SectionAllocator:Alloc (name, t)
	self.SectionStack [#self.SectionStack]:AddChild (section)
	self.SectionStack [#self.SectionStack + 1] = section
	
	return #self.SectionStack
end

function self:EndSection (index, t)
	local index = index or #self.SectionStack
	local t     = t     or SysTime ()
	
	if not self.SectionStack [index] then return end
	
	if #self.SectionStack == index then
		self.SectionStack [index]:End (t)
		self.SectionStack [index] = nil
	else
		for i = #self.SectionStack, i, -1 do
			self.SectionStack [i]:End (t)
			self.SectionStack [i] = nil
		end
	end
end

function self:Wrap (f, name)
	return function (...)
		local token = self:BeginSection (name)
		local r1, r2, r3, r4, r5, r6 = f (...)
		self:EndSection (token)
		
		return r1, r2, r3, r4, r5, r6
	end
end

-- Internal, do not call
function self:ScrubFrame (frame)
	for section in frame:GetRootSection ():GetChildEnumerator () do
		self.SectionAllocator:Free (section)
	end
	
	frame:Clear ()
end

function self:ScrubSection (section)
	for childSection in section:GetChildEnumerator () do
		self.SectionAllocator:Free (childSection)
	end
	
	section:Clear ()
end
