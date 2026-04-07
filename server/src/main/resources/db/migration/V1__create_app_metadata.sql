CREATE TABLE app_metadata (
    metadata_key VARCHAR(100) PRIMARY KEY,
    metadata_value VARCHAR(255) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO app_metadata (metadata_key, metadata_value)
VALUES ('schema.baseline', '1'),
       ('app.name', 'base-project-api'),
       ('app.version', '0.1.0-SNAPSHOT'),
       ('app.status', 'UP');
