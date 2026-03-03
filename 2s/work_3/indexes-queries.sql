EXPLAIN (ANALYZE, BUFFERS)
SELECT id, passport_id, crossing_time 
FROM analytics.border_crossing 
WHERE metadata @> '{"device": "scanner_0"}';

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, inspection_time, result 
FROM analytics.luggage_inspection 
WHERE prohibited_items && ARRAY['knife', 'battery'];

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, crossing_time, declaration_text 
FROM analytics.border_crossing 
WHERE metadata ? 'customs_declaration';


EXPLAIN (ANALYZE, BUFFERS)
SELECT id, screening_time, geo_location 
FROM analytics.criminal_screening 
ORDER BY geo_location <-> point(55.75, 37.61) 
LIMIT 5;

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, biometry_id, threat_level 
FROM analytics.criminal_screening 
WHERE screening_window && tsrange('2026-02-18 18:00', '2026-02-19 12:00');

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, passport_id, total_crossings 
FROM analytics.passenger_profile 
WHERE active_period @> DATE '2024-06-15';