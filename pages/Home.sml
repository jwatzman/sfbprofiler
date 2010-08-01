structure Home :> PAGE = struct
	fun handler s _ _ = ("Home", Web.HTML (User.name (Session.user s)))
end
