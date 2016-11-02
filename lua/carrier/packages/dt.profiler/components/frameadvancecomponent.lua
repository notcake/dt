local self = {}
Profiler.FrameAdvanceComponent = Class (self, Profiler.ProfilerComponent)

function self:ctor (profiler)
	self.Profiler = profiler
end

-- ProfilerComponent
function self:OnEnabled ()
	hook.Add ("HUDShouldDraw", "dt.FrameAdvanceComponent",
		function (_)
			local frame = self.Profiler:GetCurrentFrame ()
			local lastFrameIndex = frame and frame:GetIndex ()
			
			local currentFrameIndex = FrameNumber ()
			if lastFrameIndex == currentFrameIndex then return end
			
			self.Profiler:AdvanceFrame (currentFrameIndex)
		end
	)
end

function self:OnDisabled ()
	hook.Remove ("HUDShouldDraw", "dt.FrameAdvanceComponent")
end
