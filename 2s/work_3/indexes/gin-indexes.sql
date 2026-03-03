-- CREATE INDEX idx_border_crossing_metadata_gin 
-- ON analytics.border_crossing 
-- USING GIN (metadata);

-- CREATE INDEX idx_luggage_inspection_prohibited_gin 
-- ON analytics.luggage_inspection 
-- USING GIN (prohibited_items);

-- SELECT id, passport_id, crossing_time 
-- FROM analytics.border_crossing 
-- WHERE metadata @> '{"device": "scanner_0"}';

-- SELECT id, inspection_time, result 
-- FROM analytics.luggage_inspection 
-- WHERE prohibited_items && ARRAY['knife', 'battery'];

-- SELECT id, crossing_time, declaration_text 
-- FROM analytics.border_crossing 
-- WHERE metadata ? 'customs_declaration';