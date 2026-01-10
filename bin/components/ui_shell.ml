let render =
 fun children ->
  let open Dream_html in
  let open HTML in
  html
    [ lang "en" ]
    [
      head []
        [
          title [] "Josh Felton Mathews";
          link [ rel "stylesheet"; path_attr href Static.Assets.app_css ];
        ];
      body [] [ h1 [] [ txt "Josh Felton Mathews" ]; children ];
    ]
