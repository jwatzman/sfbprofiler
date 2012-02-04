signature FACEBOOK = sig
	type facebook
	val load : Web.request -> facebook option
	val appId : string

	val uid : facebook -> Int64.int
	val name : facebook -> string
end
