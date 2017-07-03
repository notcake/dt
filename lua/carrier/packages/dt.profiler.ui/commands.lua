function RegisterCommands ()	
	concommand.Add ("+dt", function (ply, cmd, args) GetWindow ():SetVisible (true)  end)
	concommand.Add ("-dt", function (ply, cmd, args) GetWindow ():SetVisible (false) end)
	
	concommand.Add ("dt_toggle",
		function (ply, cmd, args)
			GetWindow ():SetVisible (not GetWindow ():IsVisible ())
		end
	)
end

function UnregisterCommands ()
	concommand.Remove ("+dt")
	concommand.Remove ("-dt")
	
	concommand.Remove ("dt_toggle")
end
