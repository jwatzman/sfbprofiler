structure Login :> PAGE = struct
	fun handler _ _ _ = ("Login", Web.HTML "You need to log in")
end
