local self = {}
Profiler.Profiler = Class(self)

self.FrameEnded = Event()

function self:ctor()
	self.Frames = CircularBuffer(256)
	self.CurrentFrame = nil
	self.SectionStack = {}
end

function self:BeginFrame(index, t)
	local t = t or SysTime()
	
	if self.CurrentFrame then
		self:EndFrame(t)
	end
	
	self.CurrentFrame = Profiler.Frame.Alloc(index, t)
	self.SectionStack[1] = self.CurrentFrame:GetRootSection()
end

function self:EndFrame(t)
	local t = t or SysTime()
	
	local currentFrame = self.CurrentFrame
	if currentFrame == nil then return end
	
	self.CurrentFrame = nil
	
	self:EndSection(2, t)
	self.SectionStack[1] = nil
	
	currentFrame:End(t)
	
	if self.Frames:GetCount() == self.Frames:GetCapacity() then
		self.Frames:Pop():Release()
	end
	self.Frames:Push(currentFrame)
	
	self.FrameEnded:Dispatch(currentFrame)
end

function self:AdvanceFrame(index, t)
	local t = t or SysTime()
	
	self:EndFrame(t)
	self:BeginFrame(index, t)
end

function self:GetCurrentFrame()
	return self.CurrentFrame
end

function self:GetFrames()
	return self.Frames
end

function self:GetLastFrame()
	return self.Frames:Get(-1)
end

function self:BeginSection(name, t)
	if not self.CurrentFrame then
		self:BeginFrame(0)
	end

	local t = t or SysTime()
	
	local section = Profiler.Section.Alloc(name, t)
	self.SectionStack[#self.SectionStack]:AddChild(section)
	self.SectionStack[#self.SectionStack + 1] = section
	
	return #self.SectionStack
end

function self:EndSection(index, t)
	local index = index or #self.SectionStack
	local t     = t     or SysTime()
	
	if index == 1 then return end
	if not self.SectionStack[index] then return end
	
	if #self.SectionStack == index then
		self.SectionStack[index]:End(t)
		self.SectionStack[index] = nil
	else
		for i = #self.SectionStack, index, -1 do
			self.SectionStack[i]:End(t)
			self.SectionStack[i] = nil
		end
	end
end

function self:Wrap(f, name)
	return function(...)
		local token = self:BeginSection(name)
		local r1, r2, r3, r4, r5, r6 = f(...)
		self:EndSection(token)
		
		return r1, r2, r3, r4, r5, r6
	end
end
