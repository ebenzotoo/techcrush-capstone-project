const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
app.use(cors());

const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  host: process.env.DB_HOST || 'db',
  database: process.env.DB_NAME || 'capstonedb',
  password: process.env.DB_PASSWORD || 'password',
  port: 5432,
});

app.get('/api/init', async (req, res) => {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS projects (
        id SERIAL PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        tech_stack VARCHAR(255) NOT NULL
      );
      TRUNCATE TABLE projects;
      INSERT INTO projects (title, tech_stack) VALUES
      ('MentMate Platform', 'Flutter, Supabase'),
      ('Ghana Law Society Portal', 'WordPress, PHP'),
      ('Personal Portfolio', 'Next.js, Supabase');
    `);
    res.send('Database initialized successfully! You can now check your frontend.');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error: ' + err.message);
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Backend API running on port ${PORT}`);
});