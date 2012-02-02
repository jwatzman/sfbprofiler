structure SaveCharacter :> PAGE = struct
	exception SaveCharacterError of string

	fun handler session args form =
		(let
			val owner =
				case session of
					NONE => raise SaveCharacterError "Not logged in"
					| SOME s => Session.user s

			val charidstr =
				case Form.get form "charid" of
					NONE => raise SaveCharacterError "Invalid character"
					| SOME s => s

			val charid =
				case Int.fromString charidstr of
					NONE => raise SaveCharacterError "Invalid character"
					| SOME i => i

			val character =
				case Character.load charid owner of
					NONE => raise SaveCharacterError "Invalid character"
					| SOME c => c

			val () = Character.update character form
		in
			raise WebUtil.redirect "/"
		end)
			handle SaveCharacterError s =>
				Response.new ("Error saving character", Web.HTML s)
end
