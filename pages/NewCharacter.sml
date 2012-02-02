structure NewCharacter :> PAGE = struct
	exception NewCharacterError of string

	fun handler session args form =
		(let
			val owner =
				case session of
					NONE => raise NewCharacterError "Not logged in"
					| SOME s => Session.user s

			val name =
				case Form.get form "name" of
					NONE => raise NewCharacterError "No name specified"
					| SOME n => n

			val ctypestr =
				case Form.get form "ctype" of
					NONE =>
						raise NewCharacterError "No character type specified"
					| SOME s => s

			val ctypeint =
				case Int.fromString ctypestr of
					NONE => raise NewCharacterError "Non-integer character type"
					| SOME i => i

			val ctype =
				case CharacterType.intToType ctypeint of
					NONE => raise NewCharacterError "Invalid character type"
					| SOME c => c

			val () = Character.new owner name ctype
		in
			raise WebUtil.redirect "/"
		end)
			handle NewCharacterError s =>
				Response.new ("Error creating character", Web.HTML s)
end
