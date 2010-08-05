structure Login :> PAGE = struct
	fun handler _ _ _ =
		("Login", TLogin.render {appId = Facebook.appId})
end
