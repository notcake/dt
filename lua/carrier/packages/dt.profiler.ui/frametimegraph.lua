local self = {}
FrameTimeGraph = Class (self, Glass.View)

function self:ctor (profiler)
	self.Profiler = profiler
	
	self.Graph = FrameTimeGraph.Graph (self)
	self.Graph:SetParent (self)
	
	self.VerticalAxisFont  = Glass.Font("rer", 10)
	self.VerticalAxisWidth = 0
end

-- IView
-- Internal
function self:OnSkinChanged (skin)
	self.VerticalAxisFont = skin:GetCaptionFont ()
end

function self:Render (w, h, render2d)
	local graphY = self.Graph:GetY ()
	for _, v in ipairs ({ 1 / 60, 1 / 30, 1 / 20 }) do
		local label = string.format ("%.1f ms", v * 1000)
		self:GetEnvironment ():GetTextRenderer ():DrawTextAligned (label, self.VerticalAxisFont, self:GetSkin ():GetTextColor (), self.VerticalAxisWidth - 4, graphY + self.Graph:GetDurationY (v), Glass.HorizontalAlignment.Right, Glass.VerticalAlignment.Center)
	end
	
	-- Bounding rectangle for graph
	render2d:DrawRectangle (Color.LightGray, self.VerticalAxisWidth, 0, w - self.VerticalAxisWidth, h)
end

function self:OnLayout (w, h)
	self.VerticalAxisWidth = self:GetEnvironment ():GetTextRenderer ():GetTextSize ("16.7 ms", self.VerticalAxisFont) + 8
	
	-- Graph (inset 1px to allow for bounding rectangle)
	self.Graph:SetRectangle (self.VerticalAxisWidth + 1, 1, w - self.VerticalAxisWidth - 2, h - 2)
end

-- FrameTimeGraph
function self:GetProfiler ()
	return self.Profiler
end
