let default_msg = {|Options:
    db migrate 
    db --help
|}

let () =
  let subcommand =
    try Array.get Sys.argv 1 with Invalid_argument _ -> default_msg
  in
  Printf.printf "%s" subcommand;
  exit 0

(*
let () =
  let open Sqlite3 in
  let db = db_open "homepage" in
  let _ = db_close db in
  Printf.printf "Successfully opened db";
  exit 0
  *)
