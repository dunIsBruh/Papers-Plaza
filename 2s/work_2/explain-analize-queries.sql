EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM analytics.passenger_profile
WHERE passport_id = 4900;

EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM analytics.luggage_inspection
WHERE notes like 'Inspection note 2%';

EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM analytics.luggage_inspection
WHERE item_count >= 16;

EXPLAIN (ANALYZE, BUFFERS)
SELECT * from analytics.criminal_screening
WHERE screening_score BETWEEN 6 AND 9;

EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM analytics.border_crossing
WHERE transport_type IN ('TRAIN', 'BUS');