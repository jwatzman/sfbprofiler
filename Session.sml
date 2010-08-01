structure Session :> SESSION = struct
	type session = (Web.request *
	{
		uid : int,
		name : string
	} option)

	exception NotLoggedIn

	(*
		Call this to force the second half of the session to be SOME, reporting
		programmer error if it is not.
	*)
	fun loggedinSession (req, sopt) = case sopt of
		NONE => raise NotLoggedIn
		| SOME(s) => s

	fun load req = case SQL.getUserByCookie "foo" of
		NONE => (req, NONE)
		| SOME {uid, name} => (req, SOME {uid = uid, name = name})

	fun loggedin (req, sopt) = Option.isSome sopt

	fun requireLogin (req, sopt) = case loggedin (req, sopt) of
		true => ()
		| false => raise WebUtil.redirectPostpath req ["login"]

	fun uid (s:session) = #uid (loggedinSession s)

	fun name (s:session) = #name (loggedinSession s)
end
