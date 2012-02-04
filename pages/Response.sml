structure Response :> RESPONSE = struct
	type response = {
		title : string,
		body : Web.html,
		css : string list
	}

	fun new (title, body) : response = {title = title, body = body, css = []}

	fun addCss {title, body, css} newCss =
		{title = title, body = body, css = newCss::css}

	val cssBase = "http://sfbprofiler.jwatzman.org:8081/"

	fun render {title, body, css} =
		TPage.render {
			title = title,
			body = body,
			css = map (fn c => cssBase ^ c) ("static/page.css"::css)
		}
end
