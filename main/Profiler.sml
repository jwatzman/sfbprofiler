structure Profiler :> PROFILER = struct
	(*
		Primary dispatch. Ensures they're logged in, figures out the handler
		to use, calls that handler, and then renders the result.
	*)
	fun dispatch req args page =
	let
		val session = Session.load req

		val handler = case page of
			"login" => Login.handler
			| _ =>
			let
				val () = Session.requireLogin session
			in
				case page of
					"" => Home.handler
					| _ => raise WebUtil.notFound
			end

		val form = Form.load req

		(* TODO some way to set the cookie *)
		val (title, body) = handler session args form
	in
		WebUtil.htmlResp (TPage.render {title=title, body=body})
	end

	(*
		Root request handler. Just makes sure the postpath is non-empty and
		hands off control to the dispatcher.
	*)
	fun handler req = case WebUtil.postpath req of
		[] => dispatch req [] ""
		| page::args => dispatch req args page

	(*
		Boilerplate stuff to get the app rolling.
	*)
	val db = SQLite.opendb "sfbprofiler.sqlite"
	val () = SQL.prepare db

	val app = (*WebUtil.dumpRequestWrapper print*) (WebUtil.exnWrapper handler)

	fun main () =
	let
		val () = print "Listening...\n"
		val () = HTTPServer.serve (INetSock.any 8080) app
	in
		()
	end
end