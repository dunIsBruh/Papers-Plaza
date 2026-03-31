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


CREATE PUBLICATION pub_criminal_root
    FOR TABLE analytics.criminal_screening_part
    WITH (publish_via_partition_root = on);

