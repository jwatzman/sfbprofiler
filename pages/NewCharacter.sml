structure NewCharacter :> PAGE = struct
	exception NewCharacterError of string

	fun handler session args form =
		(let
			val owner =
				case session of
					NONE => raise NewCharacterError "Not logged in"
					| SOME s => User.uid (Session.user s)

			val name =
				case Form.get form "name" of
					NONE => raise NewCharacterError "No name specified"
					| SOME n => n

			val ctype =
				case Form.get form "ctype" of
					NONE =>
						raise NewCharacterError "No character type specified"
					| SOME ctypestr =>
						(case Int.fromString ctypestr of
							NONE =>
								raise NewCharacterError
									"Non-integer character type"
							| SOME ctype =>
								if CharacterType.valid ctype
									then ctype
									else
										raise NewCharacterError
											"Invalid character type")

			val () = SQL.newCharacter (owner, name, ctype)
		in
			Home.handler session args form
		end)
			handle NewCharacterError s =>
				("Error creating character", Web.HTML s)
end
