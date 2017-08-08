local self = {}
UI.Window = Class (self, Glass.Window)

function self:ctor (profiler)
	self.Profiler = profiler
	
	self:SetTitle ("dt")
	self:SetSize (800, 600)
	self:Center ()
	
	self.FrameTimeGraphHeading = Glass.Label ()
	self.FrameTimeGraphHeading:SetParent (self)
	self.FrameTimeGraphHeading:SetFont (Glass.Skin.Default.Fonts.Headline)
	self.FrameTimeGraphHeading:SetText ("Frame Render Times")
	self.FrameTimeGraph = FrameTimeGraph (self.Profiler)
	self.FrameTimeGraph:SetParent (self)
	
	self.FPSLabel = Glass.Label ()
	self.FPSLabel:SetParent (self)
	self.FPSLabel:SetHorizontalAlignment (Glass.HorizontalAlignment.Right)
	
	self.CallTreeHeading = Glass.Label ()
	self.CallTreeHeading:SetParent (self)
	self.CallTreeHeading:SetFont (Glass.Skin.Default.Fonts.Headline)
	self.CallTreeHeading:SetText ("Call Tree")
	
	self.CallTreeTableView = CallTreeTableView (self.Profiler)
	self.CallTreeTableView:SetParent (self)
	
	self:GetHandle ().PaintOver = function (_)
		Profiler.Profiler:EndSection ()
	end
end

function self:dtor ()
	self.Profiler.FrameEnded:RemoveListener (self:GetHashCode ())
end

-- IView
-- Internal
function self:OnLayout (w, h)
	if not self.FrameTimeGraph then return end
	
	local y = 4
	self.FrameTimeGraphHeading:SetRectangle (4, y, self.FrameTimeGraphHeading:GetPreferredSize ())
	self.FPSLabel:SetRectangle (4, y, w - 8, self.FrameTimeGraphHeading:GetHeight ())
	y = y + self.FrameTimeGraphHeading:GetHeight ()
	y = y + 4
	self.FrameTimeGraph:SetRectangle (4, y, w - 8, 128)
	y = y + self.FrameTimeGraph:GetHeight ()
	
	y = y + 16
	self.CallTreeHeading:SetRectangle (4, y, self.CallTreeHeading:GetPreferredSize ())
	y = y + self.CallTreeHeading:GetHeight ()
	y = y + 4
	self.CallTreeTableView:SetRectangle (4, y, w - 8, h - 4 - y)
end

function self:OnVisibleChanged (visible)
	if visible then
		self.Profiler.FrameEnded:AddListener (self:GetHashCode(),
			function (frame)
				self:SetFrame (frame)
			end
		)
		self:SetFrame (self.Profiler:GetLastFrame ())
	else
		self.Profiler.FrameEnded:RemoveListener (self:GetHashCode ())
	end
end

function self:Render (w, h, render2d)
	Glass.Window:GetFlattenedMethodTable ().Render (self, w, h, render2d)
	
	Profiler.Profiler:BeginSection ("dt.Profiler.UI.Window:PaintChildren")
end

-- Window
function self:SetFrame (frame)
	local duration = frame and frame:GetDuration () or 0
	self.FPSLabel:SetText (string.format ("%.1f fps", 1 / duration))
	
	self.CallTreeTableView:SetFrame (frame)
end
