structure CharacterType = struct
	exception UnknownCharacterType of int

	datatype ctype = TEST

	fun typeToInt TEST = 0

	fun typeToString TEST = "TEST"

	fun intToType 0 = TEST
	  | intToType n = raise UnknownCharacterType n
end
