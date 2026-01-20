type t = {
  migration_id : int;
  filename_up : string;
  filename_down : string;
  created_at : Row.timestamp option;
  updated_at : Row.timestamp option;
  applied : bool;
}

type order_t = ASC | DESC

let insert_migration_query =
  {|
INSERT INTO migrations (filename_up, filename_down) values
  ($1, $2);
|}

let insert_migration filename_up filename_down =
  let _ =
    Conn.send_query
      ~params:[| filename_up; filename_down |]
      ~param_types:Postgresql.[| oid_of_ftype TEXT; oid_of_ftype TEXT |]
      insert_migration_query
  in
  ()

let parse_row row =
  {
    migration_id = row |> Row.get_int "migration_id";
    filename_up = row |> Row.get_string "filename_up";
    filename_down = row |> Row.get_string "filename_down";
    created_at = row |> Row.get_timestamp "created_at";
    updated_at = row |> Row.get_timestamp "updated_at";
    applied = row |> Row.get_bool "applied";
  }

let get_migrations_query_asc =
  {|
  SELECT * FROM migrations ORDER BY created_at ASC; 
  |}

let get_migrations_query_desc =
  {|
  SELECT * FROM migrations ORDER BY created_at DESC; 
  |}

let get_migrations order =
  let query =
    match order with
    | ASC -> get_migrations_query_asc
    | DESC -> get_migrations_query_desc
  in
  Conn.send_query query |> List.map parse_row

let print_migration migration =
  print_endline "{";
  Printf.printf "  migration_id : %i \n" migration.migration_id;
  Printf.printf "  filename_up : %s \n" migration.filename_up;
  Printf.printf "  filename_down : %s \n" migration.filename_down;
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
      ~param_types:Postgresql.[| oid_of_ftype BOOL; oid_of_ftype INT8 |]
      update_migrations_query
  in
  print_endline "Updated migration"
