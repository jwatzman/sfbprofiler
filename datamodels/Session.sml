structure Session :> SESSION = struct
	type session = {
		req : Web.request,
		user : User.user option
	}

	exception NotLoggedIn

	fun user (s : session) = case #user s of
		NONE => raise NotLoggedIn
		| SOME(u) => u

	fun load req = {req = req, user = User.loadFromCookie "foo"}

	fun loggedin (s : session) = Option.isSome (#user s)

	fun requireLogin (s : session) = case loggedin s of
		true => ()
		| false => raise WebUtil.redirectPostpath (#req s) ["login"]
end
