CREATE TABLE analytics.border_crossing_part (
    id BIGINT GENERATED ALWAYS AS IDENTITY,

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

    created_at TIMESTAMP NOT NULL DEFAULT now(),

    PRIMARY KEY (id, transport_type)
) PARTITION BY LIST (transport_type);



CREATE TABLE analytics.border_crossing_car
    PARTITION OF analytics.border_crossing_part
        FOR VALUES IN ('CAR');

CREATE TABLE analytics.border_crossing_bus
    PARTITION OF analytics.border_crossing_part
        FOR VALUES IN ('BUS');

CREATE TABLE analytics.border_crossing_air
    PARTITION OF analytics.border_crossing_part
        FOR VALUES IN ('AIR');

CREATE TABLE analytics.border_crossing_train
    PARTITION OF analytics.border_crossing_part
        FOR VALUES IN ('TRAIN');

CREATE TABLE analytics.border_crossing_default
    PARTITION OF analytics.border_crossing_part
        DEFAULT;



CREATE TABLE analytics.criminal_screening_part (
    id BIGINT GENERATED ALWAYS AS IDENTITY,

    biometry_id INT NOT NULL REFERENCES identity.biometry(id),

    screening_time TIMESTAMP NOT NULL,

    match_found BOOLEAN NOT NULL,

    threat_level SMALLINT, -- NULL если match_found = false

    case_type_id INT REFERENCES Criminal.CaseType(id),

    screening_score NUMERIC(6,3) NOT NULL,

    geo_location POINT, -- геометрический тип

    screening_window TSRANGE, -- range

    additional_info JSONB,

    PRIMARY KEY (id, biometry_id)
) PARTITION BY HASH (biometry_id);



CREATE TABLE analytics.criminal_screening_p0
    PARTITION OF analytics.criminal_screening_part
        FOR VALUES WITH (MODULUS 4, REMAINDER 0);

CREATE TABLE analytics.criminal_screening_p1
    PARTITION OF analytics.criminal_screening_part
        FOR VALUES WITH (MODULUS 4, REMAINDER 1);

CREATE TABLE analytics.criminal_screening_p2
    PARTITION OF analytics.criminal_screening_part
        FOR VALUES WITH (MODULUS 4, REMAINDER 2);

CREATE TABLE analytics.criminal_screening_p3
    PARTITION OF analytics.criminal_screening_part
        FOR VALUES WITH (MODULUS 4, REMAINDER 3);



CREATE TABLE analytics.luggage_inspection_part (
    id BIGINT GENERATED ALWAYS AS IDENTITY,

    luggage_id INT NOT NULL REFERENCES Items.Luggage(id),
    officer_id INT NOT NULL,

    inspection_time TIMESTAMP NOT NULL,

    result VARCHAR(20) NOT NULL CHECK (result IN ('CLEAR', 'CONFISCATED', 'WARNING')),

    suspicious_score NUMERIC(5,2) NOT NULL,

    item_count INT NOT NULL,

    prohibited_items TEXT[],

    notes TEXT,

    inspection_duration INTERVAL,

    extra_data JSONB,

    PRIMARY KEY (id, inspection_time)
) PARTITION BY RANGE (inspection_time);


CREATE TABLE analytics.luggage_inspection_2026_01
    PARTITION OF analytics.luggage_inspection_part
        FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');

CREATE TABLE analytics.luggage_inspection_2026_02
    PARTITION OF analytics.luggage_inspection_part
        FOR VALUES FROM ('2026-02-01') TO ('2026-03-01');

CREATE TABLE analytics.luggage_inspection_2026_03
    PARTITION OF analytics.luggage_inspection_part
        FOR VALUES FROM ('2026-03-01') TO ('2026-04-01');

CREATE TABLE analytics.luggage_inspection_2026_04
    PARTITION OF analytics.luggage_inspection_part
        FOR VALUES FROM ('2026-04-01') TO ('2026-05-01');

CREATE TABLE analytics.luggage_inspection_default
    PARTITION OF analytics.luggage_inspection_part
        DEFAULT;
