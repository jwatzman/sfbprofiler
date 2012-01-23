signature CHARACTER = sig
	type character
	exception ShortCharacter

	(* load by character ID *)
	val load : int -> User.user -> character option

	(* load all characters by a given owner; the characters returned here are
	   "short" and will raise ShortCharacter if you call get on them *)
	val loadByOwner : User.user -> character list

	val new : User.user -> string -> CharacterType.ctype -> unit

	val charid : character -> int
	val name : character -> string
	val ctype : character -> CharacterType.ctype

	val get : character -> string -> string

	(* character id -> owner -> data -> success? *)
	val update : int -> int -> Form.form -> bool
end
