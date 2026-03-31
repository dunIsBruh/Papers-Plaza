--- border
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


CREATE PUBLICATION pub_border_rootless
    FOR TABLE analytics.border_crossing_part
    WITH (publish_via_partition_root = off);
