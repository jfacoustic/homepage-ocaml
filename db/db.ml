let default_msg =
  {|Options:
    db migrate new
    db migrate up
    db migrate down
    db reset
    db --help
|}

let exit_with_msg msg =
  print_endline msg;
  exit

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

let apply_migration filename =
  let ic = open_in filename in
  let query = In_channel.input_all ic in
  let db = Sqlite3.db_open "homepage" in
  let _ =
    match Sqlite3.exec db query with
    | Sqlite3.Rc.OK -> Printf.printf "Applied migration %s\n" filename
    | _ -> failwith (Sqlite3.errmsg db)
  in
  let _ = Sqlite3.db_close db in
  close_in ic

let apply_migrations () =
  Sys.readdir "migrations"
  |> Array.to_list (* Sort files in reverse order *)
  |> List.sort (fun f1 f2 -> get_timestamp f1 - get_timestamp f2)
  |> List.iter (fun f -> apply_migration (Printf.sprintf "migrations/%s" f))

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
    exit_with_msg "Not in Project Root" (-1)
  else
    exec ()
