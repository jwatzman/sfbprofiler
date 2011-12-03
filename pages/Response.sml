structure Response :> RESPONSE = struct
	type response = {
		title : string,
		body : Web.html,
		css : string list
	}

	fun new (title, body) : response = {title = title, body = body, css = []}

	fun addCss {title, body, css} newCss =
		{title = title, body = body, css = newCss::css}

	fun render resp = TPage.render (addCss resp "static/page.css")
end
