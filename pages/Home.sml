structure Home :> PAGE = struct
	fun handler NONE args form = Login.handler NONE args form
	  | handler (SOME s) _ _ = ("Home",
	  	let
	  		val user = Session.user s
	  	in
			TCharacterList.render {
				user = user,
				characters = Character.loadByOwner (User.uid user)
			}
	  	end)
end
