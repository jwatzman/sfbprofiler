structure Session :> SESSION = struct
	type session = {
		user : User.user,
		facebook : Facebook.facebook
	}

	fun load req = NONE

	fun user (s : session) = #user s
end
