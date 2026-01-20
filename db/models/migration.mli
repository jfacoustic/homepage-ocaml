type t = {
  migration_id : int;
  filename_up : string;
  filename_down : string;
  created_at : Row.timestamp;
  updated_at : Row.timestamp option;
  applied : bool;
}

type order_t = ASC | DESC

val insert_migration : string -> string -> unit
val get_migrations : order_t -> t list
val update_migration : t -> unit
val print_migration : t -> unit
