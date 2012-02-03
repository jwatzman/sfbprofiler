structure CharacterType = struct

	datatype ctype = APOC | TEST

	fun typeToInt APOC = 0
	  | typeToInt TEST = 1

	fun typeToString APOC = "Apocolypse World"
	  | typeToString TEST = "Test"

	fun intToType 0 = SOME(APOC)
	  | intToType 1 = SOME(TEST)
	  | intToType _ = NONE

	val ctypes = map (fn t => (typeToInt t, typeToString t)) [TEST, APOC]

	fun valid n = Option.isSome (intToType n)
end
