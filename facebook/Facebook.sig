signature FACEBOOK = sig
	type facebook
	val load : Web.request -> facebook option
	val appId : string
end
