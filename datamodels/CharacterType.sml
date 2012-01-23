structure CharacterType = struct

	datatype ctype = APOC

	fun typeToInt APOC = 0

	fun typeToString APOC = "Apocolypse World"

	fun intToType 0 = SOME(APOC)
	  | intToType _ = NONE

	val ctypes = map (fn t => (typeToInt t, typeToString t)) [APOC]

	fun valid n = Option.isSome (intToType n)
end
