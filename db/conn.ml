let conninfo =
  match Sys.getenv_opt "PG_URL" with
  | Some p -> p
  | None -> failwith "PG_URL not set"

let conn = new Postgresql.connection ~conninfo ()

let instance () =
  conn#set_notice_processor (fun s ->
      Printf.eprintf "postgresql error [%s]\n" s);
  conn

let print_res conn res =
  let open Postgresql in
  let open Printf in
  match res#status with
  | Empty_query -> printf "Empty query\n"
  | Command_ok -> printf "Command ok [%s]\n" res#cmd_status
  | Tuples_ok ->
      printf "Tuples ok\n";
      printf "%i tuples with %i fields\n" res#ntuples res#nfields;
      print_endline (String.concat ";" res#get_fnames_lst);
      for tuple = 0 to res#ntuples - 1 do
        for field = 0 to res#nfields - 1 do
          printf "%s, " (res#getvalue tuple field)
        done;
        print_newline ()
      done
  | Copy_out ->
      printf "Copy out:\n";
      conn#copy_out print_endline
  | Copy_in ->
      printf "Copy in, not handled!\n";
      exit 1
  | Bad_response ->
      printf "Bad response: %s\n" res#error;
      conn#reset
  | Nonfatal_error -> printf "Non fatal error: %s\n" res#error
  | Fatal_error -> printf "Fatal error: %s\n" res#error
  | Copy_both ->
      printf "Copy in/out, not handled!\n";
      exit 1
  | Single_tuple ->
      printf "Single tuple, not handled!\n";
      exit 1

let rec dump_res conn =
  match conn#get_result with
  | Some res ->
      print_res conn res;
      flush stdout;
      dump_res conn
  | None -> ()

let send_query ?param_types ?params ?binary_params ?binary_result query =
  conn#send_query ?param_types ?params ?binary_params ?binary_result query;
  dump_res conn

let finish () = conn#finish
