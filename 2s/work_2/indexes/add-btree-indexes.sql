CREATE INDEX IF NOT EXISTS passenger_passport_id 
ON analytics.passenger_profile (passport_id);

CREATE INDEX IF NOT EXISTS notes_in_luggage_inspection 
ON analytics.luggage_inspection (notes);

CREATE INDEX IF NOT EXISTS item_count_in_luggage_inspection
ON analytics.luggage_inspection (item_count);

CREATE INDEX IF NOT EXISTS screening_score_in_criminal_screening
ON analytics.criminal_screening (screening_score);

CREATE INDEX IF NOT EXISTS transport_type_in_border_crossing
ON analytics.border_crossing (transport_type);