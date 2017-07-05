local self = {}
FrameTimeGraph = Class (self, Phoenix.View)

function self:ctor (profiler)
	self.Profiler = profiler
	
	self.BarWidth   = 6
	self.BarSpacing = 2
end

-- IView
function self:Render (w, h, render2d)
	local frames = self.Profiler:GetFrames ()
	local frameCount = frames:GetCount ()
	
	local x = w - frameCount * (self.BarWidth + self.BarSpacing) + self.BarSpacing
	local y0 = h
	
	render2d:DrawLine (Color.Gray, 0, 0.25 * h, w, 0.25 * h)
	render2d:DrawLine (Color.Gray, 0, 0.50 * h, w, 0.50 * h)
	render2d:DrawLine (Color.Gray, 0, 0.75 * h, w, 0.75 * h)
	render2d:DrawLine (Color.Gray, 0, 1.00 * h - 1, w, 1.00 * h - 1)
	
	for frame in frames:GetEnumerator () do
		local duration = frame:GetDuration ()
		local h = duration / (1 / 15) * h
		local color = nil
		if duration <= 1 / 60 then
			color = Color.Green
		elseif duration <= 1 / 30 then
			color = Color.Orange
		else
			color = Color.Red
		end
		render2d:FillRectangle (color, x, y0 - h, self.BarWidth, h + 1)
		x = x + self.BarWidth + self.BarSpacing
	end
end
