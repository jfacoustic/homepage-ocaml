open Components

type post_preview = { title : string; content : string; id : int }

let post_previews =
  [
    { title = "Test Post"; content = "Hey how are you doing?"; id = 0 };
    { title = "Test Post 2"; content = "Hey how are you doing again?"; id = 1 };
  ]

let render_preview preview =
  let open Dream_html in
  let open HTML in
  div []
    [
      p [] [ txt "%s" preview.title ];
      p [] [ txt "%s" preview.content ];
      a [ href "/blog/%i" preview.id ] [ txt "View More" ];
    ]

let render _req =
  let open Dream_html in
  let open HTML in
  respond
    (Ui_shell.render
       (null
          [
            h2 []
              [
                txt
                  "I'm a software engineer and musician.  This blog is a \
                   small-web experiment in OCaml.";
              ];
            script
              [
                src
                  "https://gist.github.com/jfacoustic/24f238af3e4d5551e93787eafc70601c.js";
              ]
              "";
            div [] (List.map render_preview post_previews);
          ]))
