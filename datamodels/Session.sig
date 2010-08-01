signature SESSION = sig
	type session

	(*
		Do not catch this exception -- it is thrown only in the case of
		programmer error, when you are trying to do operations on a session
		that require it to be logged in when it is not. You should check
		beforehand that the session is logged in and handle it appropriately,
		possibly via requireLogin.
	*)
	exception NotLoggedIn

	val load : Web.request -> session

	val loggedin : session -> bool
	val requireLogin : session -> unit (* Make this "redirect" instead? *)

	val uid : session -> int
	val name : session -> string
end
