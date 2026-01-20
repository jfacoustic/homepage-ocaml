-- 202601192123_create_users_table.up.sql
CREATE TABLE IF NOT EXISTS homepage_users (
  user_id SERIAL PRIMARY KEY,
  email TEXT NOT NULL,
  password_hash TEXT NOT NULL);
