structure Login :> PAGE = struct
	fun handler _ _ _ =
		Response.new ("Login", TLogin.render {appId = Facebook.appId})
end
