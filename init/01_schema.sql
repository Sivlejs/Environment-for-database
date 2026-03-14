-- Celestial Eye – initial database schema
-- This script runs automatically when the PostgreSQL container is first started.

-- --------------------------------------------------------
-- Users / accounts
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id          SERIAL PRIMARY KEY,
    username    VARCHAR(100) NOT NULL UNIQUE,
    email       VARCHAR(255) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- --------------------------------------------------------
-- Sessions / tokens
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS sessions (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token       TEXT NOT NULL UNIQUE,
    expires_at  TIMESTAMPTZ NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- --------------------------------------------------------
-- Celestial objects (core data for the Celestial Eye backend)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS celestial_objects (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    type        VARCHAR(100),          -- e.g. star, planet, galaxy, nebula
    ra          DOUBLE PRECISION,      -- right ascension (degrees)
    dec         DOUBLE PRECISION,      -- declination (degrees)
    magnitude   REAL,
    description TEXT,
    discovered_at DATE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- --------------------------------------------------------
-- Observations logged by users
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS observations (
    id                  SERIAL PRIMARY KEY,
    user_id             INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    celestial_object_id INTEGER REFERENCES celestial_objects(id) ON DELETE SET NULL,
    observed_at         TIMESTAMPTZ NOT NULL,
    notes               TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- --------------------------------------------------------
-- Sample seed data – a handful of well-known objects
-- --------------------------------------------------------
INSERT INTO celestial_objects (name, type, ra, dec, magnitude, description)
VALUES
    ('Sun',         'star',   280.46, -23.44,  -26.74, 'Our home star'),
    ('Moon',        'satellite', 90.00, 18.00,  -12.74, 'Earth natural satellite'),
    ('Andromeda',   'galaxy', 10.68,  41.27,    3.44, 'Nearest large galaxy (M31)'),
    ('Orion Nebula','nebula',  83.82,  -5.39,    4.00, 'Stellar nursery in Orion (M42)'),
    ('Sirius',      'star',   101.29, -16.72,  -1.46, 'Brightest star in the night sky')
ON CONFLICT DO NOTHING;
