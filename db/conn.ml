open Row

let conninfo =
  match Sys.getenv_opt "PG_URL" with
  | Some p -> p
  | None -> failwith "PG_URL not set"

let conn = new Postgresql.connection ~conninfo ()

let instance () =
  conn#set_notice_processor (fun s ->
      Printf.eprintf "postgresql error [%s]\n" s);
  conn

let bool_of_psql_string fvalue =
  match fvalue with
  | "f" -> false
  | "t" -> true
  | _ -> failwith (Printf.sprintf "Error parsing boolean value: %s" fvalue)

let parse_timestamp db_timestamp =
  match Timedesc.Zoneless.of_iso8601 db_timestamp with
  | Ok value -> value
  | Error e -> failwith e

let parse_field_value cb fvalue =
  if String.length fvalue = 0 then None else Some (cb fvalue)

let parse_field name ftype fvalue =
  match ftype with
  | Postgresql.BOOL ->
      {
        name;
        value =
          parse_field_value (fun v -> TBool (bool_of_psql_string v)) fvalue;
      }
  | Postgresql.TEXT ->
      { name; value = parse_field_value (fun v -> TString v) fvalue }
  | Postgresql.VARCHAR ->
      { name; value = parse_field_value (fun v -> TString v) fvalue }
  | Postgresql.INT2 ->
      {
        name;
        value = parse_field_value (fun v -> TInt (int_of_string v)) fvalue;
      }
  | Postgresql.INT4 ->
      {
        name;
        value = parse_field_value (fun v -> TInt (int_of_string v)) fvalue;
      }
  | Postgresql.INT8 ->
      {
        name;
        value = parse_field_value (fun v -> TInt (int_of_string v)) fvalue;
      }
  | Postgresql.TIMESTAMP ->
      {
        name;
        value =
          parse_field_value (fun v -> TTimestamp (parse_timestamp v)) fvalue;
      }
  | _ -> failwith "ERROR"

let parse_db_res res =
  let result = ref [] in
  let fnames_list = res#get_fnames_lst in
  for tuple = 0 to res#ntuples - 1 do
    let row = ref [] in
    for field = 0 to res#nfields - 1 do
      let name = List.nth fnames_list field in
      let ftype = res#ftype field in
      let fvalue = res#getvalue tuple field in
      Printf.printf "\n%s %s\n" name fvalue;
      row := !row @ [ parse_field name ftype fvalue ]
    done;
    result := !result @ [ !row ]
  done;
  !result

let rec dump_res conn records =
  match conn#get_result with
  | Some res ->
      flush stdout;
      dump_res conn (records @ parse_db_res res)
  | None -> records

let send_query ?param_types ?params ?binary_params ?binary_result query =
  conn#send_query ?param_types ?params ?binary_params ?binary_result query;
  let records = dump_res conn [] in
  records

let finish () = conn#finish
