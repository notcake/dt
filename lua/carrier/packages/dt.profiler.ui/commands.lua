local desktopItem = nil

function RegisterCommands ()
	concommand.Add ("+dt", function (ply, cmd, args) GetWindow ():SetVisible (true)  end)
	concommand.Add ("-dt", function (ply, cmd, args) GetWindow ():SetVisible (false) end)
	
	concommand.Add ("dt_toggle",
		function (ply, cmd, args)
			GetWindow ():SetVisible (not GetWindow ():IsVisible ())
		end
	)
	
	desktopItem = Phoenix.Desktop:AddItem ("dt", "error")
	desktopItem.Click:AddListener (
		function ()
			GetWindow ():SetVisible (true)
		end
	)
end

function UnregisterCommands ()
	concommand.Remove ("+dt")
	concommand.Remove ("-dt")
	
	concommand.Remove ("dt_toggle")
	
	desktopItem:dtor ()
	desktopItem = nil
end
