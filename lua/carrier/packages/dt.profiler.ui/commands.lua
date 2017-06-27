function RegisterCommands ()	
	concommand.Add ("+dt", function (ply, cmd, args) Frame:SetVisible (true)  end)
	concommand.Add ("-dt", function (ply, cmd, args) Frame:SetVisible (false) end)
	
	concommand.Add ("dt_toggle",
		function (ply, cmd, args)
			Frame:SetVisible (not Frame:IsVisible ())
		end
	)
end

function UnregisterCommands ()
	concommand.Remove ("+dt")
	concommand.Remove ("-dt")
	
	concommand.Remove ("dt_toggle")
end
