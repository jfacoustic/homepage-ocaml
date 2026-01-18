val instance : unit -> Postgresql.connection

val send_query :
  ?param_types:int array ->
  ?params:string array ->
  ?binary_params:bool array ->
  ?binary_result:bool ->
  string ->
  unit

val finish : unit -> unit
