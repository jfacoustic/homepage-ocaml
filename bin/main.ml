open Routes

let live_reload : Dream.middleware =
  match Sys.getenv_opt "LIVE_RELOAD" |> Option.map String.lowercase_ascii with
  | Some "true" | Some "1" | Some "on" -> Dream.livereload
  | _ -> Dream.no_middleware

let () =
  Dream.run ~interface:"0.0.0.0"
  @@ live_reload
  @@ Dream.logger
  @@ Dream.router
       [
         Static.routes;
         Dream.get "/" Home.render;
         Dream.get "/blog/:post_id" (fun request ->
             Dream.html (Dream.param request "post_id"));
       ]
