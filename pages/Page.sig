signature PAGE = sig
	(* session -> args -> form -> (title, body) *)
	val handler : Session.session option -> string list -> Form.form
		-> (string * Web.html)
end
