signature SESSION = sig
	type session

	val load : Web.request -> session option

	val user : session -> User.user
end
