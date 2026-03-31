CREATE TABLE papers.audit_log (
    id SERIAL PRIMARY KEY,
    event_time TIMESTAMP NOT NULL DEFAULT now(),
    description TEXT NOT NULL
);