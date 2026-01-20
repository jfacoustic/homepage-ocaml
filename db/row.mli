type timestamp = Timedesc.Zoneless.zoneless

type field_data_t =
  | TBool of bool
  | TString of string
  | TInt of int
  | TTimestamp of timestamp

type field_data = { name : string; value : field_data_t option }
type t = field_data list

val get_bool : string -> t -> bool option
val get_string : string -> t -> string option
val get_int : string -> t -> int option
val get_timestamp : string -> t -> timestamp option
val string_of_timestamp : timestamp -> string
val psql_ftype_of_field_data_t : field_data_t -> Postgresql.ftype
val psql_string_of_bool : bool -> string
val required : 'a option -> 'a
