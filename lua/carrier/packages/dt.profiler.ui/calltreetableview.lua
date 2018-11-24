local self = {}
CallTreeTableView = Class(self, Glass.TreeTableView)

function self:ctor(profiler)
	self.Profiler = profiler
	self.Frame    = nil
	
	local column = self:GetColumns():Add("Name")
	column:SetWidth(300)
	
	local column = self:GetColumns():Add("Duration")
	column:SetWidth(100)
	column:SetAlignment(Glass.HorizontalAlignment.Right)
	
	local column = self:GetColumns():Add("Visual")
	column:SetWidth(300)
	column:SetName("")
end

-- CallTreeTableView
function self:GetProfiler()
	return self.Profiler
end

function self:SetFrame(frame)
	if self.Frame == frame then return end
	
	local previousFrame = self.Frame
	self.Frame = frame
	if self.Frame then
		self.Frame:AddRef()
	end
	if previousFrame then
		previousFrame:Release()
	end
	
	self:ClearItems()
	
	local tableViewItem = Glass.TableViewItem(self.Frame:GetName())
	tableViewItem:SetColumnText("Name",     self.Frame:GetName())
	tableViewItem:SetColumnText("Duration", Util.Duration.Format(self.Frame:GetDuration()))
	tableViewItem:SetColumnRenderer("Visual",
		function(tableViewItem, w, h, render2d)
			render2d:FillRectangle(Color.CornflowerBlue, 0, 6, w, h - 12)
		end
	)
	
	self:AddItem(tableViewItem)
	
	self:PopulateChildren(tableViewItem, self.Frame, self.Frame:GetRootSection(), 1)
end

function self:PopulateChildren(treeTableViewItem, frame, section, n)
	for section in section:GetChildEnumerator() do
		local tableViewItem = Glass.TableViewItem(section:GetName())
		tableViewItem:SetColumnText("Name",     string.rep(" ", n * 4) .. section:GetName())
		tableViewItem:SetColumnText("Duration", Util.Duration.Format(section:GetDuration()))
		tableViewItem:SetColumnRenderer("Visual",
			function(tableViewItem, w, h, render2d)
				local t0 = (section:GetStartTime() - frame:GetStartTime()) / frame:GetDuration()
				local dt = section:GetDuration() / frame:GetDuration()
				render2d:FillRectangle(Color.CornflowerBlue, t0 * w, 6, math.max(1, dt * w), h - 12)
			end
		)
		
		self:AddItem(tableViewItem)
		
		self:PopulateChildren(tableViewItem, frame, section, n + 1)
	end
end
