local self = {}
FrameTimeGraph = Class (self, Phoenix.View)

function self:ctor (profiler)
	self.Profiler = profiler
	
	self.Graph = FrameTimeGraph.Graph (self)
	self.Graph:SetParent (self)
	
	self.VerticalAxisFont = Phoenix.Skin.Default.Fonts.Caption
	self.VerticalAxisWidth = 0
end

-- IView
function self:Render (w, h, render2d)
	local graphY = self.Graph:GetY ()
	for _, v in ipairs ({ 1 / 60, 1 / 30, 1 / 20 }) do
		local label = string.format ("%.1f ms", v * 1000)
		Phoenix.TextRenderer:DrawTextAligned (label, self.VerticalAxisFont, Phoenix.Skin.Default.Colors.Text, self.VerticalAxisWidth - 4, graphY + self.Graph:GetDurationY (v), Phoenix.HorizontalAlignment.Right, Phoenix.VerticalAlignment.Center)
	end
	
	-- Bounding rectangle for graph
	render2d:DrawRectangle (Color.LightGray, self.VerticalAxisWidth, 0, w - self.VerticalAxisWidth, h)
end

function self:OnLayout (w, h)
	self.VerticalAxisWidth = Phoenix.TextRenderer:GetTextSize ("16.7 ms", self.VerticalAxisFont) + 8
	
	-- Graph (inset 1px to allow for bounding rectangle)
	self.Graph:SetRectangle (self.VerticalAxisWidth + 1, 1, w - self.VerticalAxisWidth - 2, h - 2)
end

-- FrameTimeGraph
function self:GetProfiler ()
	return self.Profiler
end
