let read_file filename =
  let ic = open_in filename in
  In_channel.input_all ic

let apply_migration migration =
  let open Migration in
  let query = read_file migration.filename in
  let _ = Conn.send_query query in
  Migration.update_migration { migration with applied = true }

let handle_migration migration =
  let open Migration in
  if migration.applied then print_endline "Migration already applied"
  else apply_migration migration

let rec iter_migrations migrations =
  match migrations with
  | [] -> print_endline "Finished migrating!"
  | migration :: rest ->
      handle_migration migration;
      iter_migrations rest

let exec () =
  Sys.chdir "migrations";
  Migration.get_migrations () |> iter_migrations
