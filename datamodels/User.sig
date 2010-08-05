signature USER = sig
	type user

	val load : int -> user option
	val new : int -> string -> user

	val uid : user -> int
	val name : user -> string
end
