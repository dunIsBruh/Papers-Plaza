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
);


CREATE SUBSCRIPTION sub_criminal_root
    CONNECTION 'host=pg_publisher port=5432 dbname=course_db user=postgres password=pass'
    PUBLICATION pub_criminal_root
    WITH (copy_data = true);