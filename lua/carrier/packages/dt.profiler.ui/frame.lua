local self = {}
UI.Frame = Class (self)

function self:ctor (profiler)
	self.Profiler = profiler
	
	self.Frame = vgui.Create ("DFrame")
	self.Frame:SetTitle ("dt")
	
	self.Frame:SetDeleteOnClose (false)
	self.Frame:MakePopup ()
	self.Frame:SetKeyboardInputEnabled (false)
	
	self.Frame:SetSize (800, 600)
	self.Frame:Center ()
	self.Frame:SetVisible (false)
	
	self.Label = vgui.Create ("DLabel", self.Frame)
	self.Label:Center ()
	
	self.Profiler.FrameEnded:AddListener (self:GetHashCode(),
		function (_, frame)
			self.Label:SetText (Util.Duration.Format (frame:GetDuration ()))
		end
	)
end

function self:dtor ()
	self.Profiler.FrameEnded:RemoveListener (self:GetHashCode ())

	if self.Frame then
		self.Frame:Remove ()
		self.Frame = nil
	end
end

function self:IsVisible ()
	return self.Frame:IsVisible ()
end

function self:SetVisible (visible)
	if self:IsVisible () == visible then return end
	
	self.Frame:SetVisible (visible)
end
