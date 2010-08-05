structure Profiler :> PROFILER = struct
	(*
		Primary dispatch. Ensures they're logged in, figures out the handler
		to use, calls that handler, and then renders the result.
	*)
	fun dispatch req args page =
	let
		val handler = case page of
			"" => Home.handler
			| "login" => Login.handler
			| _ => raise WebUtil.notFound

		val sessionopt = Session.load req
		val form = Form.load req

		val (title, body) = handler sessionopt args form
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
