INSERT INTO analytics.border_crossing_part
(
    passport_id,
    crossing_time,
    checkpoint_code,
    direction,
    transport_type,
    risk_level,
    officer_id,
    declaration_text,
    metadata,
    luggage_weight_range
)
SELECT
    b.passport_id,
    b.crossing_time,
    b.checkpoint_code,
    b.direction,
    b.transport_type,
    b.risk_level,
    b.officer_id,
    b.declaration_text,
    b.metadata,
    b.luggage_weight_range
FROM analytics.border_crossing b;


INSERT INTO analytics.luggage_inspection_part
(
    luggage_id,
    officer_id,
    inspection_time,
    result,
    suspicious_score,
    item_count,
    prohibited_items,
    notes,
    inspection_duration,
    extra_data
)
SELECT
    l.luggage_id,
    l.officer_id,
    l.inspection_time,
    l.result,
    l.suspicious_score,
    l.item_count,
    l.prohibited_items,
    l.notes,
    l.inspection_duration,
    l.extra_data
FROM analytics.luggage_inspection l;


INSERT INTO analytics.luggage_inspection_part
(
    luggage_id,
    officer_id,
    inspection_time,
    result,
    suspicious_score,
    item_count,
    prohibited_items,
    notes,
    inspection_duration,
    extra_data
)
SELECT
    l.id,
    (random()*500)::int,
    now() - (random()*2000 || ' hours')::interval,
    (ARRAY['CLEAR','CONFISCATED','WARNING'])[floor(random()*3+1)],
    random()*100,
    (random()*10)::int,
    CASE WHEN random() < 0.2 THEN NULL
         ELSE ARRAY['knife','liquid','battery']
    END,
    CASE WHEN random() < 0.15 THEN NULL
         ELSE 'Inspection note ' || md5(random()::text)
    END,
    (random()*60 || ' minutes')::interval,
    jsonb_build_object('scanner_version', 'v' || (random()*3)::int)
FROM items.luggage l;


INSERT INTO analytics.criminal_screening_part
(
    biometry_id,
    screening_time,
    match_found,
    threat_level,
    case_type_id,
    screening_score,
    geo_location,
    screening_window,
    additional_info
)
SELECT
    c.biometry_id,
    c.screening_time,
    c.match_found,
    c.threat_level,
    c.case_type_id,
    c.screening_score,
    c.geo_location,
    c.screening_window,
    c.additional_info
FROM analytics.criminal_screening c;