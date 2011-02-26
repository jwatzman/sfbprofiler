signature CHARACTER = sig
	type character
	exception ShortCharacter

	(* load by character ID *)
	val load : int -> character option

	(* load all characters by a given owner; the characters returned here are
	   "short" and will raise ShortCharacter if you call get on them *)
	val loadByOwner : int -> character list

	(* owner ID -> name -> type -> unit *)
	(* TODO should this return a character? *)
	val new : int -> string -> unit

	val charid : character -> int
	val name : character -> string
	val ctype : character -> CharacterType.ctype

	val get : character -> string -> string

	(* character id -> owner -> data -> success? *)
	val update : int -> int -> Form.form -> bool
end
