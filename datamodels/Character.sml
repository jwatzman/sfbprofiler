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

	fun get _ _ = raise Fail ""

	fun load _ = raise Fail ""

	fun loadByOwner owner =
		let
			val fromdb = SQL.getShortCharactersForOwner owner
			fun dbtochar {charid, name, ctype} = {
				charid = charid,
				name = name,
				ctype = CharacterType.intToType ctype,
				data = NONE
			}
		in
			map dbtochar fromdb
		end

	fun new _ _ = raise Fail ""

	fun update _ _ _ = raise Fail ""
end
