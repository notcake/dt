local self = {}
Profiler.FrameAdvanceComponent = Class (self, Profiler.ProfilerComponent)

function self:ctor (profiler)
	self.Profiler = profiler
end

-- ProfilerComponent
function self:OnEnabled ()
	self:AddPrePostHook ("DrawOpaqueRenderables")
	self:AddPrePostHook ("DrawTranslucentRenderables")
	self:AddPrePostHook ("DrawSkyBox")
	self:AddPrePostHook ("PlayerDraw")
	self:AddPrePostHook ("DrawEffects")
	self:AddPrePostHook ("DrawHUD")
	
	hook.Add ("PreDrawViewModel", "dt.FrameAdvanceComponent",
		function (viewModel, ply, weapon)
			if not viewModel then return end
			self.Profiler:BeginSection ("DrawViewModel")
		end
	)
	hook.Add ("PostDrawViewModel", "dt.FrameAdvanceComponent",
		function (viewModel, ply, weapon)
			if not viewModel then return end
			self.Profiler:EndSection ()
		end
	)
	
	hook.Add ("PrePlayerDraw", "dt.FrameAdvanceComponent",
		function (ply)
			self.Profiler:BeginSection ("PlayerDraw (" .. ply:Name () .. ")")
		end
	)
	hook.Add ("PostPlayerDraw", "dt.FrameAdvanceComponent", function (ply) self.Profiler:EndSection () end)
	
	hook.Add ("PreRender", "dt.FrameAdvanceComponent",
		function ()
			self.Profiler:BeginSection ("Render")
		end
	)
	hook.Add ("PostRender", "dt.FrameAdvanceComponent",
		function (_)
			self.Profiler:EndSection ()
			
			local frame = self.Profiler:GetCurrentFrame ()
			local lastFrameIndex = frame and frame:GetIndex ()
			
			local currentFrameIndex = FrameNumber ()
			if lastFrameIndex == currentFrameIndex then return end
			
			self.Profiler:AdvanceFrame (currentFrameIndex)
		end
	)
end

function self:OnDisabled ()
	self:RemovePrePostHook ("Render")
	self:RemovePrePostHook ("DrawOpaqueRenderables")
	self:RemovePrePostHook ("DrawTranslucentRenderables")
	self:RemovePrePostHook ("DrawSkyBox")
	self:RemovePrePostHook ("PlayerDraw")
	self:RemovePrePostHook ("DrawViewModel")
	self:RemovePrePostHook ("DrawEffects")
	self:RemovePrePostHook ("DrawHUD")
end

-- Internal
function self:AddPrePostHook (name)
	hook.Add ("Pre" .. name, "dt.FrameAdvanceComponent",
		function ()
			self.Profiler:BeginSection (name)
		end
	)
	hook.Add ("Post" .. name, "dt.FrameAdvanceComponent",
		function ()
			self.Profiler:EndSection ()
		end
	)
end

function self:RemovePrePostHook (name)
	hook.Remove ("Pre"  .. name, "dt.FrameAdvanceComponent")
	hook.Remove ("Post" .. name, "dt.FrameAdvanceComponent")
end
