CREATE TABLE [IF NOT EXISTS] blog_posts (
  blog_post_id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT current_timestamp,
  updated_at TEXT NOT NULL DEFAULT current_timestamp
);
