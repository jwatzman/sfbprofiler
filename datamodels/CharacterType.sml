structure CharacterType = struct
	exception UnknownCharacterType of int

	datatype ctype = TEST

	fun typeToInt TEST = 0

	fun typeToString TEST = "TEST"

	fun intToType 0 = TEST
	  | intToType n = raise UnknownCharacterType n

	val ctypes = map (fn t => (typeToInt t, typeToString t)) [TEST]

	fun valid n =
	(let
		val _ = intToType n
	in
		true
	end) handle UnknownCharacterType _ => false
end
