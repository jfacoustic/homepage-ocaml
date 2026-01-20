let whitespace = Str.regexp " +"

let gen_filenames (desc : string) (current_time : Unix.tm) =
  let filename = Str.global_replace whitespace "_" desc in
  let prefix =
    Printf.sprintf "%i%02i%02i%02i%02i_%s"
      (current_time.tm_year + 1900)
      (current_time.tm_mon + 1) current_time.tm_mday current_time.tm_hour
      current_time.tm_min filename
  in
  (prefix ^ ".up.sql", prefix ^ ".down.sql")

let create_file filename =
  let oc = open_out filename in
  Printf.fprintf oc "-- %s\n" filename;
  close_out oc;
  filename

let gen_files desc =
  let filename_up, filename_down =
    Unix.time () |> Unix.localtime |> gen_filenames desc
  in
  Sys.chdir "migrations";
  (create_file filename_up, create_file filename_down)

let exec desc =
  let filename_up, filename_down = gen_files desc in
  Migration.insert_migration filename_up filename_down
