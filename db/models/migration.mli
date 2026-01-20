type t = {
  migration_id : int;
  filename : string;
  created_at : Timedesc.Zoneless.zoneless;
  applied : bool;
}

val insert_migration : string -> unit
val get_migrations : unit -> t list
val update_migration : t -> unit
val print_migration : t -> unit
