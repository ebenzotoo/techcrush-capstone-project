CREATE TABLE IF NOT EXISTS projects (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    tech_stack VARCHAR(100) NOT NULL
);

INSERT INTO projects (title, tech_stack) VALUES ('mentmate App', 'Flutter & Supabase');
INSERT INTO projects (title, tech_stack) VALUES ('Digital Operations Infrastructure', 'WordPress & Cloud Integrations');
INSERT INTO projects (title, tech_stack) VALUES ('NextEra Masterclass Platform', 'Web Development & Project Management');