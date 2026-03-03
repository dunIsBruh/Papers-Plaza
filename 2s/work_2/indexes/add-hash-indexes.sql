CREATE INDEX IF NOT EXISTS hashed_passenger_passport_id 
ON analytics.passenger_profile USING hash(passport_id);

CREATE INDEX IF NOT EXISTS hashed_notes_in_luggage_inspection 
ON analytics.luggage_inspection USING hash(notes);

CREATE INDEX IF NOT EXISTS hashed_item_count_in_luggage_inspection
ON analytics.luggage_inspection USING hash(item_count);

CREATE INDEX IF NOT EXISTS hashed_screening_score_in_criminal_screening
ON analytics.criminal_screening USING hash(screening_score);

CREATE INDEX IF NOT EXISTS hashed_transport_type_in_border_crossing
ON analytics.border_crossing USING hash(transport_type);