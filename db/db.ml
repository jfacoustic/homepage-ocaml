let help_str =
  {|
Args:

migrate new "{description}"
migrate up
migrate down
init
|}

let conninfo =
  match Sys.getenv_opt "PG_URL" with
  | Some p -> p
  | None -> failwith "PG_URL not set"

let migrate_down () = print_endline "migrate down"

let cmd () =
  match Array.to_list Sys.argv with
  | [ _; "migrate"; "new"; desc ] -> Create_new_migration.exec desc
  | [ _; "migrate"; "up" ] -> Migrate_up.exec ()
  | [ _; "migrate"; "down" ] -> migrate_down ()
  | [ _; "init" ] -> Init_migrations_table.exec ()
  | _ -> print_endline help_str

let _ =
  Printf.printf "Connecting to DB: %s \n\n" conninfo;
  cmd ()
