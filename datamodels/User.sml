structure User :> USER = struct
	type user = {
		uid : int,
		name : string,
		cookie : string
	}

	fun loadFromCookie c = case SQL.getUserByCookie c of
		NONE => NONE
		| SOME({uid, name}) => SOME({uid = uid, name = name, cookie = c})

	fun uid (u : user) = #uid u
	fun name (u : user) = #name u
	fun cookie (u : user) = #cookie u
end
