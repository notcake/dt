local self = {}
Profiler.FrameAdvanceComponent = Class (self, Profiler.ProfilerComponent)

Profiler.FrameAdvanceComponent.FirstHookName = "dt.FrameAdvanceComponent.\xc2\x52\xd1\xfa"
Profiler.FrameAdvanceComponent.LastHookName  = "dt.FrameAdvanceComponent.\x89\x45\x9b\xad"

function self:ctor (profiler)
	self.Profiler = profiler
	
	self.WorldPanelFirst = nil
	self.WorldPanelLast  = nil
end

-- ProfilerComponent
function self:OnEnabled ()
	self.WorldPanelFirst = vgui.CreateX ("Panel")
	self.WorldPanelFirst:SetSize (0, 0)
	self.WorldPanelFirst:SetZPos (-32768)
	self.WorldPanelLast = vgui.CreateX ("Panel")
	self.WorldPanelLast:SetSize (0, 0)
	self.WorldPanelLast:SetZPos (32767)
	self.WorldPanelFirst.Think = function ()
		if self.WorldPanelLast:GetZPos () ~= 32767 then
			self.WorldPanelLast:SetZPos (32767)
		end
		self.Profiler:BeginSection ("vgui.GetWorldPanel() InternalThinkTraverse")
	end
	self.WorldPanelLast.Think = function ()
		self.Profiler:EndSection ()
	end
	
	self:AddPrePostHook ("DrawOpaqueRenderables")
	self:AddPrePostHook ("DrawTranslucentRenderables")
	self:AddPrePostHook ("DrawSkyBox")
	self:AddPrePostHook ("PlayerDraw")
	self:AddPrePostHook ("DrawEffects")
	self:AddPrePostHook ("DrawHUD")
	
	for _, eventName in ipairs ({ "Think", "Tick", "CreateMove", "StartCommand" }) do
		hook.Add (eventName, Profiler.FrameAdvanceComponent.FirstHookName,
			function ()
				self.Profiler:BeginSection (eventName)
			end
		)
		hook.Add (eventName, Profiler.FrameAdvanceComponent.LastHookName,
			function ()
				self.Profiler:EndSection ()
			end
		)
	end
	
	hook.Add ("SetupMove", Profiler.FrameAdvanceComponent.FirstHookName,
		function ()
			self.Profiler:BeginSection ("SetupMove / Move / FinishMove")
		end
	)
	hook.Add ("FinishMove", Profiler.FrameAdvanceComponent.LastHookName,
		function ()
			self.Profiler:EndSection ()
		end
	)
	
	hook.Add ("PreDrawViewModel", Profiler.FrameAdvanceComponent.FirstHookName,
		function (viewModel, ply, weapon)
			if not viewModel then return end
			self.Profiler:BeginSection ("DrawViewModel")
		end
	)
	hook.Add ("PostDrawViewModel", Profiler.FrameAdvanceComponent.LastHookName,
		function (viewModel, ply, weapon)
			if not viewModel then return end
			self.Profiler:EndSection ()
		end
	)
	
	hook.Add ("PrePlayerDraw", Profiler.FrameAdvanceComponent.FirstHookName,
		function (ply)
			self.Profiler:BeginSection ("PlayerDraw (" .. ply:Name () .. ")")
		end
	)
	hook.Add ("PostPlayerDraw", Profiler.FrameAdvanceComponent.LastHookName, function (ply) self.Profiler:EndSection () end)
	
	hook.Add ("PreRender", Profiler.FrameAdvanceComponent.FirstHookName,
		function ()
			-- print (FrameNumber (), "PreRender")
			self.Profiler:BeginSection ("Render")
		end
	)
	hook.Add ("PostRender", Profiler.FrameAdvanceComponent.LastHookName,
		function (_)
			-- print (FrameNumber (), "PostRender")
			self.Profiler:EndSection ()
			
			local frame = self.Profiler:GetCurrentFrame ()
			local lastFrameIndex = frame and frame:GetIndex ()
			
			local currentFrameIndex = FrameNumber () + 1
			if lastFrameIndex == currentFrameIndex then return end
			
			self.Profiler:AdvanceFrame (currentFrameIndex)
		end
	)
end

function self:OnDisabled ()
	if self.WorldPanelFirst then
		self.WorldPanelFirst:Remove ()
		self.WorldPanelFirst = nil
	end
	if self.WorldPanelLast then
		self.WorldPanelLast:Remove ()
		self.WorldPanelLast = nil
	end
	
	for _, eventName in ipairs ({ "Think", "Tick", "CreateMove", "StartCommand" }) do
		hook.Remove (eventName, Profiler.FrameAdvanceComponent.FirstHookName)
		hook.Remove (eventName, Profiler.FrameAdvanceComponent.LastHookName)
	end
	
	hook.Remove ("SetupMove",  Profiler.FrameAdvanceComponent.FirstHookName)
	hook.Remove ("FinishMove", Profiler.FrameAdvanceComponent.LastHookName)
	
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
	hook.Add ("Pre" .. name, Profiler.FrameAdvanceComponent.FirstHookName,
		function ()
			self.Profiler:BeginSection (name)
		end
	)
	hook.Add ("Post" .. name, Profiler.FrameAdvanceComponent.LastHookName,
		function ()
			self.Profiler:EndSection ()
		end
	)
end

function self:RemovePrePostHook (name)
	hook.Remove ("Pre"  .. name, Profiler.FrameAdvanceComponent.FirstHookName)
	hook.Remove ("Post" .. name, Profiler.FrameAdvanceComponent.LastHookName)
end
