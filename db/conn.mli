val instance : unit -> Postgresql.connection

val send_query :
  ?param_types:int array ->
  ?params:string array ->
  ?binary_params:bool array ->
  ?binary_result:bool ->
  string ->
  Row.t list

val finish : unit -> unit
