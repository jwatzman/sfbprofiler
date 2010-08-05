structure Facebook :> FACEBOOK = struct

	type facebook = unit

	val appId = "133494973358693"
	val apiKey = "edfb83d2b913a739de23c6243a7c9050"
	val appSecret = "31e0220e582afb413b1fde95f5828350"

	fun load (req : Web.request) = NONE

	fun getCookie (req : Web.request) =
	let
		val cookieStr = case WebUtil.http_header "HTTP_COOKIE" req of
			SOME s => s
			| NONE => ""

		fun isSep c = (c = #" ") orelse (c = #";")
	in
		NONE
	end

end
