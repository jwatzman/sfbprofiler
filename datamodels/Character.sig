signature CHARACTER = sig
	type character
	exception ShortCharacter
	exception UnknownCharacterType

	(* load by character ID *)
	val load : int -> character option

	(* load all characters by a given owner; the characters returned here are
	   "short" and will raise ShortCharacter if you call get on them *)
	val loadByOwner : int -> character list

	(* owner ID -> name -> unit *)
	(* TODO should this return a character? *)
	val new : int -> string -> unit

	val id : character -> int
	val ctype : character -> CharacterType.t
	val name : character -> string
	val get : character -> string -> string (* TODO should return Form.form? *)

	(* writes to DB *)
	val update : character -> Form.form -> unit
end
