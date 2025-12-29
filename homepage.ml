let routes =
  [
    Dream.get "/" (fun _ -> Dream.html "hello");
    Dream.get "/blog" (fun _ -> Dream.html "list of blog post previews");
    (* Dream.post "/blog" *)
    Dream.get "/blog/:post_id" (fun request ->
        Dream.html (Dream.param request "post_id"));
    (* Dream.put "/blog/:post_id" *)
    (* Dream.post "/blog/:post_id/comments" *)
    (* Dream.put "/blog/:post_id/comments/:comment_id" *)
    (* Dream.get "/login" *)
    (* Dream.post "/login" *)
    (* Dream.delete "/logout" *)
  ]

let () = Dream.run @@ Dream.logger @@ Dream.router routes
