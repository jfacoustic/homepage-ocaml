type timestamp = Timedesc.Zoneless.zoneless

type field_data_t =
  | TBool of bool
  | TString of string
  | TInt of int
  | TTimestamp of timestamp

type field_data = { name : string; value : field_data_t }
type t = field_data list

val get_bool : string -> t -> bool
val get_string : string -> t -> string
val get_int : string -> t -> int
val get_timestamp : string -> t -> timestamp
val string_of_timestamp : timestamp -> string
