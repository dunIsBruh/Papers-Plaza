-- CREATE INDEX idx_criminal_screening_geo_gist 
-- ON analytics.criminal_screening 
-- USING GiST (geo_location);

-- CREATE INDEX idx_criminal_screening_window_gist 
-- ON analytics.criminal_screening 
-- USING GiST (screening_window);

-- SELECT id, screening_time, geo_location 
-- FROM analytics.criminal_screening 
-- ORDER BY geo_location <-> point(55.75, 37.61) 
-- LIMIT 5;

-- SELECT id, biometry_id, threat_level 
-- FROM analytics.criminal_screening 
-- WHERE screening_window && tsrange('2026-02-18 18:00', '2026-02-19 12:00');

-- SELECT id, passport_id, total_crossings 
-- FROM analytics.passenger_profile 
-- WHERE active_period @> DATE '2024-06-15';