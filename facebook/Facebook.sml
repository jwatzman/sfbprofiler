structure Facebook :> FACEBOOK = struct

	exception FacebookLoadError

	open FacebookConfig

	type facebook = {
		code : string,
		uid : int
	}

	fun assertOpt NONE = raise FacebookLoadError
	  | assertOpt (SOME(s)) = s

	fun assert true = ()
	  | assert false = raise FacebookLoadError

	fun uid (f : facebook) = #uid f

	(* TODO cache access token in DB instead of name (which won't reflect
	   changes and prob violates the ToS) and re-grab the name each time *)
	fun name (f : facebook) =
	(let
		val url = "https://graph.facebook.com/me?fields=name&access_token="
			^ (#code f)

		val SOME(JSON.Object map) = JSON.fromString (Curl.curl url)
		val SOME(JSON.String name) = JSON.Map.find (map, "name")
	in
		name
	end) handle Bind => raise Fail "invalid result when caching name"

	val cookieName = "fbsr_" ^ appId

	(* this should be in stilts proper... *)
	fun getCookie req cname =
	let
		val cookieStr = case WebUtil.http_header "HTTP_COOKIE" req of
			SOME s => s
			| NONE => ""

		fun isSep c = (c = #" ") orelse (c = #";")
		val cookies = String.fields isSep cookieStr

		val cookie = List.find (String.isPrefix (cname ^ "=")) cookies
	in
		case cookie of
			SOME c => SOME (String.extract (c, size cname + 1, NONE))
			| NONE => NONE
	end

	(* The base64url spec says that strings should not be padded, but the
	   base64 deocder requires them to be, so do the padding. TODO this might
	   want to be moved into the base64 implementation. *)
	fun base64pad str =
	let
		val n = 4
		val sz = size str
		val pad_sz = n - (sz mod n)

		val padding =
			if pad_sz = n then ""
			else implode (List.tabulate (pad_sz, fn _ => #"="))

	in
		str ^ padding
	end

	fun load (req : Web.request) =
	(let
		val cookieStr = assertOpt (getCookie req cookieName)
		val (expected_hmac, data) =
			(let
				val [hmac, data] = String.tokens (fn x => x = #".") cookieStr
			in
				(assertOpt (Base64.decode (base64pad hmac)), data)
			end) handle Bind => raise FacebookLoadError

		val (algorithm, code, uid) =
			(let
				val _ = "extracting json\n"
				val SOME(json_blob) = Base64.decode (base64pad data)
				val SOME(JSON.Object map) = JSON.fromString json_blob

				val SOME(JSON.String algorithm) =
					JSON.Map.find (map, "algorithm")
				val SOME(JSON.String code) =
					JSON.Map.find (map, "code")
				val SOME(JSON.String uid) =
					JSON.Map.find (map, "user_id")
			in
				(algorithm, code, assertOpt (Int.fromString uid))
			end) handle Bind => raise FacebookLoadError

		val () = assert (algorithm = "HMAC-SHA256")
		val computed_hmac = HMAC.hmac (appSecret, data)
		val () = assert (computed_hmac = expected_hmac)
	in
		SOME({
			code = code,
			uid = uid
		})
	end) handle FacebookLoadError => NONE

end
