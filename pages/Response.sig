signature RESPONSE = sig
	type response

	(* title * body -> response *)
	val new : string * Web.html -> response

	val addCss : response -> string -> response
	val render : response -> Web.html
end
