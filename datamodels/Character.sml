structure Character :> CHARACTER = struct
	type character = {
		charid : int,
		name : string,
		ctype : CharacterType.ctype,
		data : Form.form option
	}

	exception ShortCharacter

	fun charid (c : character) = #charid c
	fun name (c : character) = #name c
	fun ctype (c : character) = #ctype c

	fun get (c : character) field =
		case #data c of
			NONE => raise ShortCharacter
			| SOME formdata => Option.getOpt (Form.get formdata field, "")

	fun load charid owner =
		let
			val fromdb = SQL.getCharacter (charid, User.uid owner)
		in
			case fromdb of
				NONE => NONE
				| SOME {charid, name, ctype, data} => SOME {
					charid = charid,
					name = name,
					ctype = Option.valOf (CharacterType.intToType ctype),
					data = SOME (Form.import data)
				}
		end

	fun loadByOwner owner =
		let
			val fromdb = SQL.getShortCharactersForOwner (User.uid owner)
			fun dbtochar {charid, name, ctype} = {
				charid = charid,
				name = name,
				ctype = Option.valOf (CharacterType.intToType ctype),
				data = NONE
			}
		in
			map dbtochar fromdb
		end

	fun new owner name ctype = SQL.newCharacter
		(User.uid owner, name, CharacterType.typeToInt ctype)

	fun update _ _ _ = raise Fail ""
end
