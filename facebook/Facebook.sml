structure Facebook :> FACEBOOK = struct

	type facebook = {
		access_token : string,
		secret : string,
		session_key : string,
		uid : int
	}

	val appId = "133494973358693"
	val apiKey = "edfb83d2b913a739de23c6243a7c9050"
	val appSecret = "31e0220e582afb413b1fde95f5828350"

	fun uid (f : facebook) = #uid f

	(* TODO lazy loading and caching *)
	fun name (f : facebook) =
	(let
		val url = "https://graph.facebook.com/me?fields=name&access_token="
			^ (#access_token f)

		val SOME(JSON.Object map) = JSON.fromString (Curl.curl url)
		val SOME(JSON.String name) = JSON.Map.find (map, "name")
	in
		name
	end) handle Bind => raise Fail "invalid result when caching name"

	val cookieName = "fbs_" ^ appId

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

	fun splitFBCookie cookieStr =
	let
		val cookieStrNoQuotes = String.extract
			(cookieStr, 1, SOME ((size cookieStr) - 2))

		val parts = String.fields (fn c => c = #"&") cookieStrNoQuotes

		fun mapper [k,v] = (WebUtil.urldecode k, WebUtil.urldecode v)
		  | mapper _ = raise Option
	in
		map (mapper o (String.fields (fn c => c = #"="))) parts
	end

	fun verifyFBSig cookieSplit =
	let
		fun findSig [] = (NONE, [])
		  | findSig ((k,v)::rest) =
			let
				val (recsig, reclist) = findSig rest
			in
				if k = "sig"
				then (SOME v, reclist)
				else (recsig, (k,v)::reclist)
			end

		val (sigopt, cookieSplitNoSig) = findSig cookieSplit

		val payload =
			foldl (fn ((k,v),a) => a ^ k ^ "=" ^ v) "" cookieSplitNoSig

		val md5 = MD5.md5 (payload ^ appSecret)
	in
		(Option.valOf sigopt) = md5
	end

	(* TODO make this only run thru the list once *)
	fun makeRecord cookieSplit =
	let
		fun findSplit s =
		let
			val (_,v) = Option.valOf
				(List.find (fn (k,_) => k = s) cookieSplit)
		in
			v
		end
	in
		{
			access_token = findSplit "access_token",
			secret = findSplit "secret",
			session_key = findSplit "session_key",
			uid = Option.valOf (Int.fromString (findSplit "uid"))
		}
	end

	fun load (req : Web.request) =
	(let
		val cookieStr = Option.valOf (getCookie req cookieName)
		val split = splitFBCookie cookieStr
	in
		if verifyFBSig split then SOME(makeRecord split) else NONE
	end) handle Option => NONE

end
