type t = {
  migration_id : int;
  filename : string;
  created_at : Row.timestamp;
  applied : bool;
}

let insert_migration_query =
  {|
INSERT INTO migrations (filename) values
  ($1);
|}

let insert_migration filename =
  let _ =
    Conn.send_query ~params:[| filename |]
      ~param_types:Postgresql.[| Postgresql.oid_of_ftype TEXT |]
      insert_migration_query
  in
  print_endline filename

let parse_row row =
  {
    migration_id = row |> Row.get_int "migration_id";
    filename = row |> Row.get_string "filename";
    created_at = row |> Row.get_timestamp "created_at";
    applied = row |> Row.get_bool "applied";
  }

let get_migrations_query =
  {|
  SELECT * FROM migrations ORDER BY created_at ASC; 
  |}

let get_migrations () =
  Conn.send_query get_migrations_query |> List.map parse_row

let print_migration migration =
  print_endline "{";
  Printf.printf "  migration_id : %i \n" migration.migration_id;
  Printf.printf "  filename : %s \n" migration.filename;
  Printf.printf "  applied : %b \n" migration.applied;
  Printf.printf "  created_at : %s \n"
    (Row.string_of_timestamp migration.created_at);
  print_endline "}"

let update_migrations_query =
  {|
  UPDATE migrations
  SET applied = $1
  WHERE migration_id = $2;
  |}

let update_migration migration =
  let _ =
    Conn.send_query
      ~params:
        [|
          Row.psql_string_of_bool migration.applied;
          string_of_int migration.migration_id;
        |]
      ~param_types:
        Postgresql.
          [| Postgresql.oid_of_ftype BOOL; Postgresql.oid_of_ftype INT8 |]
      update_migrations_query
  in
  print_endline "Updated migration"
