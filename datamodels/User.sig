signature USER = sig
	type user

	val loadFromCookie : string -> user option
	(* val new : ??? *)

	val uid : user -> int
	val name : user -> string
	val cookie : user -> string
end
