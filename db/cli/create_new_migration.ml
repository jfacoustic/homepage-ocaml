let whitespace = Str.regexp " +"

let gen_filename (desc : string) (current_time : Unix.tm) =
  let filename = Str.global_replace whitespace "_" desc in
  Printf.sprintf "%i%02i%02i%02i%02i_%s.sql"
    (current_time.tm_year + 1900)
    (current_time.tm_mon + 1) current_time.tm_mday current_time.tm_hour
    current_time.tm_min filename

let gen_file desc =
  let filename = Unix.time () |> Unix.localtime |> gen_filename desc in
  Sys.chdir "migrations";
  let oc = open_out filename in
  Printf.fprintf oc "-- %s\n" filename;
  close_out oc;
  filename

let exec desc = desc |> gen_file |> Migration.insert_migration
