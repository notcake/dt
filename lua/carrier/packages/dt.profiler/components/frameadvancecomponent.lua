local self = {}
Profiler.FrameAdvanceComponent = Class(self, Profiler.ProfilerComponent)

function self:ctor(profiler)
	self.Profiler = profiler
	
	self.WorldPanelFirst = nil
	self.WorldPanelLast  = nil
end

-- ProfilerComponent
function self:OnEnabled()
	self.WorldPanelFirst = vgui.CreateX("Panel")
	self.WorldPanelFirst:SetSize(0, 0)
	self.WorldPanelFirst:SetZPos(-32768)
	self.WorldPanelLast = vgui.CreateX("Panel")
	self.WorldPanelLast:SetSize(0, 0)
	self.WorldPanelLast:SetZPos(32767)
	self.WorldPanelFirst.Think = function()
		if self.WorldPanelLast:GetZPos() ~= 32767 then
			self.WorldPanelLast:SetZPos(32767)
		end
		self.Profiler:BeginSection("vgui.GetWorldPanel() InternalThinkTraverse")
	end
	self.WorldPanelLast.Think = function()
		self.Profiler:EndSection()
	end
	
	self:AddPrePostHook("DrawOpaqueRenderables")
	self:AddPrePostHook("DrawTranslucentRenderables")
	self:AddPrePostHook("DrawSkyBox")
	self:AddPrePostHook("PlayerDraw")
	self:AddPrePostHook("DrawEffects")
	self:AddPrePostHook("DrawHUD")
	
	for _, eventName in ipairs({ "Think", "Tick", "CreateMove", "StartCommand" }) do
		Hooks.AddPreHook(eventName, "dt.FrameAdvanceComponent",
			function()
				self.Profiler:BeginSection(eventName)
			end
		)
		Hooks.AddPostHook(eventName, "dt.FrameAdvanceComponent",
			function()
				self.Profiler:EndSection()
			end
		)
	end
	
	Hooks.AddPreHook("SetupMove", "dt.FrameAdvanceComponent",
		function()
			self.Profiler:BeginSection("SetupMove / Move / FinishMove")
		end
	)
	Hooks.AddPostHook("FinishMove", "dt.FrameAdvanceComponent",
		function()
			self.Profiler:EndSection()
		end
	)
	
	Hooks.AddPreHook("PreDrawViewModel", "dt.FrameAdvanceComponent",
		function(viewModel, ply, weapon)
			if not viewModel then return end
			self.Profiler:BeginSection("DrawViewModel")
		end
	)
	Hooks.AddPostHook("PostDrawViewModel", "dt.FrameAdvanceComponent",
		function(viewModel, ply, weapon)
			if not viewModel then return end
			self.Profiler:EndSection()
		end
	)
	
	Hooks.AddPreHook("PrePlayerDraw", "dt.FrameAdvanceComponent",
		function(ply)
			self.Profiler:BeginSection("PlayerDraw(" .. ply:Name() .. ")")
		end
	)
	Hooks.AddPostHook("PostPlayerDraw", "dt.FrameAdvanceComponent",
		function(ply)
			self.Profiler:EndSection()
		end
	)
	
	Hooks.AddPreHook("PreRender", "dt.FrameAdvanceComponent",
		function()
			-- print(FrameNumber(), "PreRender")
			self.Profiler:BeginSection("Render")
		end
	)
	Hooks.AddPostHook("PostRender", "dt.FrameAdvanceComponent",
		function(_)
			-- print(FrameNumber(), "PostRender")
			self.Profiler:EndSection()
			
			local frame = self.Profiler:GetCurrentFrame()
			local lastFrameIndex = frame and frame:GetIndex()
			
			local currentFrameIndex = FrameNumber() + 1
			if lastFrameIndex == currentFrameIndex then return end
			
			self.Profiler:AdvanceFrame(currentFrameIndex)
		end
	)
end

function self:OnDisabled()
	if self.WorldPanelFirst then
		self.WorldPanelFirst:Remove()
		self.WorldPanelFirst = nil
	end
	if self.WorldPanelLast then
		self.WorldPanelLast:Remove()
		self.WorldPanelLast = nil
	end
	
	for _, eventName in ipairs({ "Think", "Tick", "CreateMove", "StartCommand" }) do
		Hooks.RemovePreHook (eventName, "dt.FrameAdvanceComponent")
		Hooks.RemovePostHook(eventName, "dt.FrameAdvanceComponent")
	end
	
	Hooks.RemovePreHook ("SetupMove",  "dt.FrameAdvanceComponent")
	Hooks.RemovePostHook("FinishMove", "dt.FrameAdvanceComponent")
	
	self:RemovePrePostHook("Render")
	self:RemovePrePostHook("DrawOpaqueRenderables")
	self:RemovePrePostHook("DrawTranslucentRenderables")
	self:RemovePrePostHook("DrawSkyBox")
	self:RemovePrePostHook("PlayerDraw")
	self:RemovePrePostHook("DrawViewModel")
	self:RemovePrePostHook("DrawEffects")
	self:RemovePrePostHook("DrawHUD")
end

-- Internal
function self:AddPrePostHook(name)
	Hooks.AddPreHook("Pre" .. name, "dt.FrameAdvanceComponent",
		function()
			self.Profiler:BeginSection(name)
		end
	)
	Hooks.AddPostHook("Post" .. name, "dt.FrameAdvanceComponent",
		function()
			self.Profiler:EndSection()
		end
	)
end

function self:RemovePrePostHook(name)
	Hooks.RemovePreHook ("Pre"  .. name, "dt.FrameAdvanceComponent")
	Hooks.RemovePostHook("Post" .. name, "dt.FrameAdvanceComponent")
end
