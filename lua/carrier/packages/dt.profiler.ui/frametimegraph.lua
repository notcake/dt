local self = {}
FrameTimeGraph = Class (self, Phoenix.View)

function self:ctor (profiler)
	self.Profiler = profiler
	
	self.Graph = FrameTimeGraph.Graph (self)
	self.Graph:SetParent (self)
	
	self.VerticalAxisFont = Phoenix.Font.Default
	self.VerticalAxisWidth = 0
end

-- IView
function self:Render (w, h, render2d)
	for _, v in ipairs ({ 1 / 60, 1 / 30, 1 / 20 }) do
		local label = string.format ("%.1f ms", v * 1000)
		Phoenix.TextRenderer:DrawTextAligned (label, self.VerticalAxisFont, Color.Silver, self.VerticalAxisWidth - 4, self.Graph:GetDurationY (v), Phoenix.HorizontalAlignment.Right, Phoenix.VerticalAlignment.Center)
	end
end

function self:OnLayout (w, h)
	self.VerticalAxisWidth = Phoenix.TextRenderer:GetTextSize ("16.7 ms", self.VerticalAxisFont) + 8
	
	self.Graph:SetRectangle (self.VerticalAxisWidth, 0, w - self.VerticalAxisWidth, h)
end

-- FrameTimeGraph
function self:GetProfiler ()
	return self.Profiler
end
