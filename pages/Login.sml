structure Login :> PAGE = struct
	fun handler _ _ _ =
		("Login", TLogin.render {appId = Session.Facebook.appId})
end
