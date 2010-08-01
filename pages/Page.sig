signature PAGE = sig
	val handler : Session.session -> string list -> Form.form
		-> (string * Web.html)
end
