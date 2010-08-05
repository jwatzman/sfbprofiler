structure User :> USER = struct
	type user = {
		uid : int,
		name : string
	}

	fun load uid = case SQL.getUserByUid uid of
		NONE => NONE
		| SOME name => SOME {uid=uid, name=name}

	fun new uid name =
	let
		val () = SQL.newUser (uid, name)
	in
		{uid=uid, name=name}
	end

	fun uid (u : user) = #uid u
	fun name (u : user) = #name u
end
