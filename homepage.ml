let routes =
  [
    Dream.get "/" (fun _ -> Dream.html "hello");
    Dream.get "/blog" (fun _ -> Dream.html "list of blog post previews");
    (* Dream.get "/blog/create" *)
    (* Dream.post "/blog/new" *)
    Dream.get "/blog/:post_id" (fun request ->
        Dream.html (Dream.param request "post_id"));
    (* Dream.get "/blog/:post_id/edit" *)
    (* Dream.put "/blog/:post_id" *)
    (* Dream.delete "/blog/:post_id" *)
    (* Dream.get "/login" *)
    (* Dream.post "/login" *)
    (* Dream.delete "/logout" *)
  ]

let () = Dream.run @@ Dream.logger @@ Dream.router routes
