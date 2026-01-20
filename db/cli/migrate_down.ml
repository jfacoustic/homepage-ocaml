let read_file filename =
  let ic = open_in filename in
  In_channel.input_all ic

let rollback_migration migration =
  let open Migration in
  let query = read_file migration.filename_down in
  let _ = Conn.send_query query in
  Migration.update_migration { migration with applied = false }

let handle_migration migration =
  let open Migration in
  if migration.applied then rollback_migration migration
  else print_endline "No Action Taken"

let rec iter_migrations migrations =
  match migrations with
  | [] -> print_endline "Finished migrating!"
  | migration :: rest ->
      handle_migration migration;
      iter_migrations rest

let exec () =
  Sys.chdir "migrations";
  Migration.get_migrations DESC |> iter_migrations
