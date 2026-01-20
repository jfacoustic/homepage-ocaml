let init_query =
  {|
CREATE TABLE IF NOT EXISTS migrations (
  migration_id SERIAL PRIMARY KEY, 
  filename_up TEXT NOT NULL,
  filename_down TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP,
  applied BOOLEAN DEFAULT false);
|}

let exec () =
  let _ = Conn.send_query init_query in
  print_endline "Initialized Migrations Table"
