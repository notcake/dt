local self = {}
CallTreeTableView = Class (self, Glass.TreeTableView)

function self:ctor (profiler)
	self.Profiler = profiler
	self.Frame    = nil
	
	self:GetColumns ():Add ("Name"):SetWidth (400)
	self:GetColumns ():Add ("Duration"):SetAlignment (Glass.HorizontalAlignment.Right)
end

-- CallTreeTableView
function self:GetProfiler ()
	return self.Profiler
end

function self:SetFrame (frame)
	if self.Frame == frame then return end
	
	local previousFrame = self.Frame
	self.Frame = frame
	
	self:ClearItems ()
	
	local tableViewItem = Glass.TableViewItem (self.Frame:GetName ())
	tableViewItem:SetColumnText ("Name",     self.Frame:GetName ())
	tableViewItem:SetColumnText ("Duration", Util.Duration.Format (self.Frame:GetDuration ()))
	
	self:AddItem (tableViewItem)
	
	self:PopulateChildren (tableViewItem, self.Frame:GetRootSection (), 1)
end

function self:PopulateChildren (treeTableViewItem, section, n)
	for section in section:GetChildEnumerator () do
		local tableViewItem = Glass.TableViewItem (section:GetName ())
		tableViewItem:SetColumnText ("Name",     string.rep (" ", n * 8) .. section:GetName ())
		tableViewItem:SetColumnText ("Duration", Util.Duration.Format (section:GetDuration ()))
		
		self:AddItem (tableViewItem)
		
		self:PopulateChildren (tableViewItem, section, n + 1)
	end
end
