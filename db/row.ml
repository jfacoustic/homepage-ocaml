type timestamp = Timedesc.Zoneless.zoneless

type field_data_t =
  | TBool of bool
  | TString of string
  | TInt of int
  | TTimestamp of timestamp option

type field_data = { name : string; value : field_data_t }
type t = field_data list

let get_field_data name row =
  (List.find (fun field -> field.name = name) row).value

let string_of_field_data_t value =
  match value with
  | TBool _ -> "bool"
  | TString _ -> "string"
  | TInt _ -> "int"
  | TTimestamp _ -> "timestamp"

let bool_of_field_data_t value =
  match value with
  | TBool value -> value
  | _ ->
      failwith
        (Printf.sprintf "Cannot convert type %s to bool"
           (string_of_field_data_t value))

let get_bool name row = row |> get_field_data name |> bool_of_field_data_t

let string_of_field_data_t value =
  match value with
  | TString value -> value
  | _ ->
      failwith
        (Printf.sprintf "Cannot convert type %s to string"
           (string_of_field_data_t value))

let get_string name row = row |> get_field_data name |> string_of_field_data_t

let int_of_field_data_t value =
  match value with
  | TInt value -> value
  | _ ->
      failwith
        (Printf.sprintf "Cannot convert type %s to int"
           (string_of_field_data_t value))

let get_int name row = row |> get_field_data name |> int_of_field_data_t

let timestamp_of_field_data_t value =
  match value with
  | TTimestamp value -> value
  | _ ->
      failwith
        (Printf.sprintf "Cannot convert type %s to timestamp"
           (string_of_field_data_t value))

let get_timestamp name row =
  row |> get_field_data name |> timestamp_of_field_data_t

let string_of_timestamp value =
  match value with
  | Some v ->
      v |> Timedesc.Zoneless.to_timestamp_local |> Timedesc.Timestamp.to_string
  | None -> "NIL"

let psql_ftype_of_field_data_t fdt =
  match fdt with
  | TBool _ -> Postgresql.BOOL
  | TString _ -> Postgresql.TEXT
  | TInt _ -> Postgresql.INT8
  | TTimestamp _ -> Postgresql.TIMESTAMP

let psql_string_of_bool value = if value then "t" else "f"
