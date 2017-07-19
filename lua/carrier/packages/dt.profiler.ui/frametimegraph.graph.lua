local self = {}
FrameTimeGraph.Graph = Class (self, Phoenix.View)

function self:ctor (graph)
	self.Graph = graph
	
	self.BarWidth   = 6
	self.BarSpacing = 2
end

-- IView
function self:Render (w, h, render2d)
	local frames = self.Graph:GetProfiler ():GetFrames ()
	local frameCount = frames:GetCount ()
	
	local x = w - frameCount * (self.BarWidth + self.BarSpacing) + self.BarSpacing
	local y0 = h
	
	-- HACK: Need to start the line at x = -0.5 really, but surface.* only does ints.
	render2d:DrawLine (Color.LightGray, -1, 0.25 * h, w, 0.25 * h)
	render2d:DrawLine (Color.LightGray, -1, 0.50 * h, w, 0.50 * h)
	render2d:DrawLine (Color.LightGray, -1, 0.75 * h, w, 0.75 * h)
	
	for frame in frames:GetEnumerator () do
		local duration = frame:GetDuration ()
		local h = duration / (1 / 15) * h
		local color = nil
		if duration <= 1 / 60 then
			color = Color.LightGreen
		elseif duration <= 1 / 30 then
			color = Color.PeachPuff
		else
			color = Color.Pink
		end
		
		-- round the height
		h = math.floor (h + 0.5)
		render2d:FillRectangle (color, x, y0 - h, self.BarWidth, h)
		x = x + self.BarWidth + self.BarSpacing
	end
end

-- FrameTimeGraph.Graph
function self:GetDurationY (duration)
	return (1 - duration / (1 / 15)) * self:GetHeight ()
end
