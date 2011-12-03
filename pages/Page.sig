signature PAGE = sig
	(* session -> args -> form -> response *)
	val handler : Session.session option -> string list -> Form.form
		-> Response.response
end
