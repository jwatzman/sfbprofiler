structure Session :> SESSION = struct
	type session = {
		user : User.user,
		facebook : Facebook.facebook
	}

	fun load req =
	let
		val _ = Facebook.load req
	in
		NONE
	end

	fun user (s : session) = #user s
end
