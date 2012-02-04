signature USER = sig
	type user

	val load : Int64.int -> user option
	val new : Int64.int -> string -> user

	val uid : user -> Int64.int
	val name : user -> string
end
