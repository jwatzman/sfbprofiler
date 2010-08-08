structure User :> USER = struct
	type user = {
		uid : int,
		name : string
	}

	val load = SQL.getUserByUid

	fun new uid name =
	let
		val () = SQL.newUser (uid, name)
	in
		{uid=uid, name=name}
	end

	fun uid (u : user) = #uid u
	fun name (u : user) = #name u
end
