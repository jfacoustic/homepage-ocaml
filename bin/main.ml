let home_page = fun _req -> Dream.html "Home Page"

let () =
  Dream.run
  @@ Dream.livereload
  @@ Dream.logger
  @@ Dream.router
       [
         Dream.get "/" home_page;
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
