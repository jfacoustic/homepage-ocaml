let init_query =
  {|
CREATE TABLE IF NOT EXISTS migrations (
  migration_id SERIAL PRIMARY KEY, 
  filename TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  applied BOOLEAN DEFAULT false);
|}

let exec () =
  Conn.send_query init_query;
  print_endline "Initialized Migrations Table"
