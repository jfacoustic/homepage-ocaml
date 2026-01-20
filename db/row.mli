type timestamp = Timedesc.Zoneless.zoneless

type field_data_t =
  | TBool of bool
  | TString of string
  | TInt of int
  | TTimestamp of timestamp option

type field_data = { name : string; value : field_data_t }
type t = field_data list

val get_bool : string -> t -> bool
val get_string : string -> t -> string
val get_int : string -> t -> int
val get_timestamp : string -> t -> timestamp option
val string_of_timestamp : timestamp option -> string
val psql_ftype_of_field_data_t : field_data_t -> Postgresql.ftype
val psql_string_of_bool : bool -> string
