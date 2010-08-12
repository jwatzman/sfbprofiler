signature CHARACTER = sig
	type character

	(* load by character ID *)
	val load : int -> character option

	(* owner ID -> name -> unit *)
	(* TODO fix this to return a character *)
	val new : int -> string -> unit

	val owner : character -> int
	val name : character -> string
	val get : character -> string -> string option

	(* writes to DB *)
	val update : character -> Form.form -> character
end
