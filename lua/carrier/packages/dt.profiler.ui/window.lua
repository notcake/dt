local self = {}
UI.Window = Class (self, Phoenix.Window)

function self:ctor (profiler)
	self.Profiler = profiler
	
	self:SetTitle ("dt")
	self:SetSize (800, 600)
	self:Center ()
	
	self.FrameTimeGraph = FrameTimeGraph (self.Profiler)
	self.FrameTimeGraph:SetParent (self)
	
	self.Label = Phoenix.Label ()
	self.Label:SetParent (self)
	self.Label:Center ()
	
	self.Profiler.FrameEnded:AddListener (self:GetHashCode(),
		function (frame)
			self.Label:SetText (Util.Duration.Format (frame:GetDuration ()))
		end
	)
end

function self:dtor ()
	self.Profiler.FrameEnded:RemoveListener (self:GetHashCode ())
end

-- Internal
function self:OnLayout (w, h)
	if not self.FrameTimeGraph then return end
	
	self.FrameTimeGraph:SetRectangle (0, 0, w, 128)
end
