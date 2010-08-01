structure Home :> PAGE = struct
	fun handler s _ _ = ("Home", Web.HTML (Session.name s))
end
