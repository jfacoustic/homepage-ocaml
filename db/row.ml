type timestamp = Timedesc.Zoneless.zoneless

type field_data_t =
  | TBool of bool
  | TString of string
  | TInt of int
  | TTimestamp of timestamp

type field_data = { name : string; value : field_data_t option }
type t = field_data list

let get_field_data name row =
  (List.find (fun field -> field.name = name) row).value

let string_of_field_data_t_enum value =
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
           (string_of_field_data_t_enum value))

let get_bool name row =
  match row |> get_field_data name with
  | Some v -> Some (bool_of_field_data_t v)
  | None -> None

let string_of_field_data_t value =
  match value with
  | TString value -> value
  | _ ->
      failwith
        (Printf.sprintf "Cannot convert type %s to string"
           (string_of_field_data_t_enum value))

let get_string name row =
  match row |> get_field_data name with
  | Some v -> Some (string_of_field_data_t v)
  | None -> None

let int_of_field_data_t value =
  match value with
  | TInt value -> value
  | _ ->
      failwith
        (Printf.sprintf "Cannot convert type %s to int"
           (string_of_field_data_t_enum value))

let get_int name row =
  match row |> get_field_data name with
  | Some v -> Some (int_of_field_data_t v)
  | None -> None

let timestamp_of_field_data_t value =
  match value with
  | TTimestamp value -> value
  | _ ->
      failwith
        (Printf.sprintf "Cannot convert type %s to timestamp"
           (string_of_field_data_t_enum value))

let get_timestamp name row =
  match row |> get_field_data name with
  | Some v -> Some (timestamp_of_field_data_t v)
  | None -> None

let string_of_timestamp value =
  value |> Timedesc.Zoneless.to_timestamp_local |> Timedesc.Timestamp.to_string

let psql_ftype_of_field_data_t fdt =
  match fdt with
  | TBool _ -> Postgresql.BOOL
  | TString _ -> Postgresql.TEXT
  | TInt _ -> Postgresql.INT8
  | TTimestamp _ -> Postgresql.TIMESTAMP

let psql_string_of_bool value = if value then "t" else "f"

let required value =
  match value with
  | Some value -> value
  | None -> failwith "required field missing"
