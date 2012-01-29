structure EditCharacter :> PAGE = struct
	exception EditCharacterError of string

	fun handler session args form =
		(let
			val owner =
				case session of
					NONE => raise EditCharacterError "Not logged in"
					| SOME s => Session.user s

			val charidstr = case args of
				s::[] => s
				| _ => raise EditCharacterError "Invalid character ID"

			val charid = case Int.fromString charidstr of
				NONE => raise EditCharacterError "Invalid character ID"
				| SOME i => i

			val character = case Character.load charid owner of
				NONE => raise EditCharacterError "Invalid character ID"
				| SOME c => c

			val (renderer, css) = case Character.ctype character of
				APOC => (TEditApoc.render, "static/apoc.css")
		in
			Response.addCss
				(Response.new (
					"Edit Character",
					renderer {character = character}
				))
				css
		end)
			handle EditCharacterError s =>
				Response.new ("Error editing character", Web.HTML s)
end
