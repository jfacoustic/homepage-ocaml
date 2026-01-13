let default_msg =
  {|Options:
    db migrate new
    db migrate up
    db migrate down
    db reset
    db --help
|}

let whitespace = Str.regexp " +"

let get_migration_desc () =
  print_endline "Enter a description for the migration file";
  read_line () |> String.trim

let gen_filename (desc : string) (current_time : Unix.tm) =
  let filename = Str.global_replace whitespace "_" desc in
  Printf.sprintf "%i%02i%02i%02i%02i_%s.sql"
    (current_time.tm_year + 1900)
    (current_time.tm_mon + 1) current_time.tm_mday current_time.tm_hour
    current_time.tm_min filename

let new_migration desc =
  let filename = Unix.time () |> Unix.localtime |> gen_filename desc in
  Sys.chdir "migrations";
  let oc = open_out filename in
  Printf.fprintf oc "-- %s\n" desc;
  Printf.printf "Created migration: %s\n" filename;
  close_out oc

let get_timestamp filename =
  match filename |> Str.split (Str.regexp "_") with
  | [] -> failwith "Invalid filename"
  | timestamp :: _ -> int_of_string timestamp

let update_migrations_table db filename =
  let create_migrations_table =
    "CREATE TABLE IF NOT EXISTS migrations (name TEXT NOT NULL UNIQUE);"
  in
  let _ =
    match Sqlite3.exec db create_migrations_table with
    | Sqlite3.Rc.OK -> ()
    | _ -> failwith (Sqlite3.errmsg db)
  in
  let insert_migration =
    Sqlite3.prepare db "INSERT INTO migrations (name) VALUES (?);"
  in
  let _ =
    match Sqlite3.bind_text insert_migration 1 filename with
    | Sqlite3.Rc.OK -> ()
    | _ -> failwith (Sqlite3.errmsg db)
  in
  Sqlite3.step insert_migration

let check_migration db filename =
  let migration_exists =
    Sqlite3.prepare db "SELECT COUNT(*) FROM migrations WHERE name = ?"
  in
  ignore (Sqlite3.bind_text migration_exists 1 filename);
  ignore (Sqlite3.step migration_exists);
  match
    Sqlite3.Data.to_int (Array.get (Sqlite3.row_data migration_exists) 0)
  with
  | Some v -> v > 0
  | _ -> false

let apply_migration db filename =
  if check_migration db filename then
    Printf.printf "%s already applied!\n" filename
  else
    let ic = open_in (Printf.sprintf "migrations/%s" filename) in
    let query = In_channel.input_all ic in
    let _ =
      match Sqlite3.exec db query with
      | Sqlite3.Rc.OK -> Printf.printf "Applied migration %s\n" filename
      | _ -> failwith (Sqlite3.errmsg db)
    in
    let _ = update_migrations_table db filename in
    close_in ic

let apply_migrations () =
  let db = Sqlite3.db_open "homepage" in
  let _ =
    Sys.readdir "migrations"
    |> Array.to_list (* Sort files in reverse order *)
    |> List.sort (fun f1 f2 -> get_timestamp f1 - get_timestamp f2)
    |> List.iter (fun f -> apply_migration db f)
  in
  let _ = Sqlite3.db_close db in
  print_endline "Successfully updated all migrations!"

let exec () =
  match Array.to_list Sys.argv with
  | [ _; "migrate"; "new"; "--d"; desc ]
  | [ _; "migrate"; "new"; "-desc"; desc ] -> new_migration desc
  | [ _; "migrate"; "new" ] -> new_migration (get_migration_desc ())
  | [ _; "migrate"; "up" ] -> apply_migrations ()
  | [ _; "reset" ] -> print_string "Reset db"
  | _ -> print_string default_msg

let () =
  if not (Sys.file_exists "dune-project") then
    failwith "Not in Project Root"
  else
    exec ()
