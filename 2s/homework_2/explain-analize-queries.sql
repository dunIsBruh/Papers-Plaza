-- EXPLAIN (ANALYZE, BUFFERS)
-- SELECT * FROM analytics.passenger_profile
-- WHERE passport_id = 4900;

-- EXPLAIN (ANALYZE, BUFFERS)
-- SELECT * FROM analytics.luggage_inspection
-- WHERE notes like 'Inspection note 2%';


-- EXPLAIN (ANALYZE, BUFFERS)
-- SELECT * FROM analytics.luggage_inspection
-- WHERE item_count >= 16;

-- EXPLAIN (ANALYZE, BUFFERS)
-- SELECT * from analytics.criminal_screening
-- WHERE screening_score BETWEEN 6 AND 9;


-- EXPLAIN (ANALYZE, BUFFERS)
-- SELECT * FROM analytics.border_crossing
-- WHERE transport_type IN ('TRAIN', 'BUS');


-- CREATE INDEX IF NOT EXISTS passenger_passport_id 
-- ON analytics.passenger_profile (passport_id);

-- CREATE INDEX IF NOT EXISTS notes_in_luggage_inspection 
-- ON analytics.luggage_inspection (notes);

-- CREATE INDEX IF NOT EXISTS item_count_in_luggage_inspection
-- ON analytics.luggage_inspection (item_count);

-- CREATE INDEX IF NOT EXISTS screening_score_in_criminal_screening
-- ON analytics.criminal_screening (screening_score);

-- CREATE INDEX IF NOT EXISTS transport_type_in_border_crossing
-- ON analytics.border_crossing (transport_type);


-- DROP INDEX IF EXISTS analytics.passenger_passport_id;
-- DROP INDEX IF EXISTS analytics.notes_in_luggage_inspection;
-- DROP INDEX IF EXISTS analytics.item_count_in_luggage_inspection;
-- DROP INDEX IF EXISTS analytics.screening_score_in_criminal_screening;
-- DROP INDEX IF EXISTS analytics.transport_type_in_border_crossing;



-- CREATE INDEX IF NOT EXISTS hashed_passenger_passport_id 
-- ON analytics.passenger_profile USING hash(passport_id);

-- CREATE INDEX IF NOT EXISTS hashed_notes_in_luggage_inspection 
-- ON analytics.luggage_inspection USING hash(notes);

-- CREATE INDEX IF NOT EXISTS hashed_item_count_in_luggage_inspection
-- ON analytics.luggage_inspection USING hash(item_count);

-- CREATE INDEX IF NOT EXISTS hashed_screening_score_in_criminal_screening
-- ON analytics.criminal_screening USING hash(screening_score);

-- CREATE INDEX IF NOT EXISTS hashed_transport_type_in_border_crossing
-- ON analytics.border_crossing USING hash(transport_type);


-- DROP INDEX IF EXISTS analytics.hashed_passenger_passport_id;
-- DROP INDEX IF EXISTS analytics.hashed_notes_in_luggage_inspection;
-- DROP INDEX IF EXISTS analytics.hashed_item_count_in_luggage_inspection;
-- DROP INDEX IF EXISTS analytics.hashed_screening_score_in_criminal_screening;
-- DROP INDEX IF EXISTS analytics.hashed_transport_type_in_border_crossing;
