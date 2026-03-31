CREATE SCHEMA analytics;

CREATE TABLE analytics.border_crossing (
    id BIGSERIAL PRIMARY KEY,

    passport_id INT NOT NULL REFERENCES identity.passport(id),

    crossing_time TIMESTAMP NOT NULL,
    checkpoint_code VARCHAR(10) NOT NULL,

    direction VARCHAR(10) NOT NULL CHECK (direction IN ('IN', 'OUT')),
    transport_type VARCHAR(20) NOT NULL,

    risk_level SMALLINT NOT NULL, -- низкая кардинальность (1-5)

    officer_id INT NOT NULL,
    
    declaration_text TEXT,
    
    metadata JSONB,
    
    luggage_weight_range NUMRANGE, -- range
    
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE analytics.luggage_inspection (
    id BIGSERIAL PRIMARY KEY,

    luggage_id INT NOT NULL REFERENCES Items.Luggage(id),
    officer_id INT NOT NULL,

    inspection_time TIMESTAMP NOT NULL,
    
    result VARCHAR(20) NOT NULL CHECK (result IN ('CLEAR', 'CONFISCATED', 'WARNING')),
    
    suspicious_score NUMERIC(5,2) NOT NULL,
    
    item_count INT NOT NULL,
    
    prohibited_items TEXT[],
    
    notes TEXT,
    
    inspection_duration INTERVAL,
    
    extra_data JSONB
);

CREATE TABLE analytics.criminal_screening (
    id BIGSERIAL PRIMARY KEY,

    biometry_id INT NOT NULL REFERENCES identity.biometry(id),

    screening_time TIMESTAMP NOT NULL,
    
    match_found BOOLEAN NOT NULL,
    
    threat_level SMALLINT, -- NULL если match_found = false
    
    case_type_id INT REFERENCES Criminal.CaseType(id),
    
    screening_score NUMERIC(6,3) NOT NULL,
    
    geo_location POINT, -- геометрический тип
    
    screening_window TSRANGE, -- range
    
    additional_info JSONB
);

CREATE TABLE analytics.passenger_profile (
    id BIGSERIAL PRIMARY KEY,

    passport_id INT NOT NULL REFERENCES identity.passport(id),

    frequent_traveler BOOLEAN NOT NULL,
    
    total_crossings INT NOT NULL,
    
    preferred_direction VARCHAR(10),
    
    average_risk NUMERIC(4,2),
    
    profile_notes TEXT,
    
    tags TEXT[],
    
    risk_distribution JSONB,
    
    active_period DATERANGE
);