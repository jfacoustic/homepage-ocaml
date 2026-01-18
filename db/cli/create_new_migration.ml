let exec desc =
  let _ = Conn.instance () in
  print_endline desc
