local self = {}
UI.Window = Class (self, Phoenix.Window)

function self:ctor (profiler)
	self.Profiler = profiler
	
	self:SetTitle ("dt")
	self:SetSize (800, 600)
	self:Center ()
	
	self.FrameTimeGraphHeading = Phoenix.Label ()
	self.FrameTimeGraphHeading:SetParent (self)
	self.FrameTimeGraphHeading:SetFont (Phoenix.Skin.Default.Fonts.Headline)
	self.FrameTimeGraphHeading:SetText ("Frame Render Times")
	self.FrameTimeGraph = FrameTimeGraph (self.Profiler)
	self.FrameTimeGraph:SetParent (self)
	
	self.DurationLabel = Phoenix.Label ()
	self.DurationLabel:SetParent (self)
	self.DurationLabel:Center ()
	self.FPSLabel = Phoenix.Label ()
	self.FPSLabel:SetParent (self)
	self.FPSLabel:Center ()
	
	self.CallTreeHeading = Phoenix.Label ()
	self.CallTreeHeading:SetParent (self)
	self.CallTreeHeading:SetFont (Phoenix.Skin.Default.Fonts.Headline)
	self.CallTreeHeading:SetText ("Call Tree")
	
	self.CallTreeTableView = CallTreeTableView (self.Profiler)
	self.CallTreeTableView:SetParent (self)
	
	self.Profiler.FrameEnded:AddListener (self:GetHashCode(),
		function (frame)
			self.DurationLabel:SetText (Util.Duration.Format (frame:GetDuration ()))
			self.FPSLabel:SetText (string.format ("%.1f fps", 1 / frame:GetDuration ()))
		end
	)
end

function self:dtor ()
	self.Profiler.FrameEnded:RemoveListener (self:GetHashCode ())
end

-- Internal
function self:OnLayout (w, h)
	if not self.FrameTimeGraph then return end
	
	local y = 4
	self.FrameTimeGraphHeading:SetRectangle (4, y, self.FrameTimeGraphHeading:GetContentSize ())
	y = y + self.FrameTimeGraphHeading:GetHeight ()
	y = y + 4
	self.FrameTimeGraph:SetRectangle (4, y, w - 8, 128)
	y = y + self.FrameTimeGraph:GetHeight ()
	
	y = y + 8
	self.CallTreeHeading:SetRectangle (4, y, self.CallTreeHeading:GetContentSize ())
	y = y + self.CallTreeHeading:GetHeight ()
	y = y + 4
	self.CallTreeTableView:SetRectangle (4, y, w - 8, h - 4 - y)
end
