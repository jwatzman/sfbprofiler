structure Session :> SESSION = struct
	structure Facebook = struct
		val appId = "133494973358693"
		val apiKey = "edfb83d2b913a739de23c6243a7c9050"
		val appSecret = "31e0220e582afb413b1fde95f5828350"
	end

	type session = {
		req : Web.request,
		user : User.user option
	}

	exception NotLoggedIn

	fun user (s : session) = case #user s of
		NONE => raise NotLoggedIn
		| SOME(u) => u

	fun load (req:Web.request) =
	let
		fun printer (hname,hval) = print (hname ^ "=" ^ hval ^ "\n")
		val _ = map printer (#http_headers req)
	in
		{req = req, user = User.loadFromCookie "foo"}
	end

	fun loggedin (s : session) = Option.isSome (#user s)

	fun requireLogin (s : session) = case loggedin s of
		true => ()
		| false => raise WebUtil.redirectPostpath (#req s) ["login"]
end
