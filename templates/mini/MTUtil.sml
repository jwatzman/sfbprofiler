structure MTUtil = struct
	fun get formdata name = Option.getOpt (Form.get formdata name, "")
end
