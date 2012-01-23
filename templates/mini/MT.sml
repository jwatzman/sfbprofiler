structure MT = struct
	local
		fun dammitj4cbo (character, name) =
			{character = character, name = name}
	in
		val cbox = MTcbox.render o dammitj4cbo
		val text = MTtext.render o dammitj4cbo
		val smtext = MTsmtext.render o dammitj4cbo
		val ta = MTta.render o dammitj4cbo
	end
end
