structure Session :> SESSION = struct
	type session = {
		user : User.user,
		facebook : Facebook.facebook
	}

	fun load req =
	(let
		val fb = Option.valOf (Facebook.load req)
		val uid = Facebook.uid fb

		val userOpt = User.load uid
		val user = case userOpt of
			SOME u => u
			| NONE => User.new uid "Default Name"
	in
		SOME {user = user, facebook = fb}
	end) handle Option => NONE

	fun user (s : session) = #user s
end
