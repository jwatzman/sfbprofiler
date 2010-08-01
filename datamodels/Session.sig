signature SESSION = sig
	type session

	structure Facebook : sig
		val appId : string
		val apiKey : string
		val appSecret : string
	end

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

	val user : session -> User.user
end
