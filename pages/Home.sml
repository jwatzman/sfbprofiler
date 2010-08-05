structure Home :> PAGE = struct
	fun handler NONE args form = Login.handler NONE args form
	| handler (SOME s) _ _ = ("Home", Web.HTML (User.name (Session.user s)))
end
