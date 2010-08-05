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
		NONE
	end

	fun splitFBCookie cookieStr =
	let
		val parts = String.fields (fn c => c = #"&") cookieStr

		fun mapper [k,v] = (k,v)
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

	fun load (req : Web.request) =
	(let
		val cookieStr = Option.valOf (getCookie req cookieName)
		val _ = print (cookieStr ^ "\n")
	in
		NONE
	end) handle Option => NONE

end
