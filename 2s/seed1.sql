INSERT INTO analytics.border_crossing
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
    p.id,
    now() - (random()*1000 || ' hours')::interval,

    -- skewed distribution
    CASE
        WHEN random() < 0.7 THEN 'CHK_A'
        ELSE 'CHK_' || (random()*9)::int
        END,

    (ARRAY['IN','OUT'])[floor(random()*2+1)],

    (ARRAY['CAR','BUS','AIR','TRAIN'])[floor(random()*4+1)],

    (random()*4 + 1)::int,

    (random()*500)::int,

    CASE WHEN random() < 0.15 THEN NULL
         ELSE 'Declaration text ' || md5(random()::text)
        END,

    jsonb_build_object(
            'device', 'scanner_' || (random()*5)::int,
            'priority', random()
    ),

    numrange(
            (random()*10)::numeric,
            ((random()+1)*50)::numeric
    )
FROM identity.passport p;



INSERT INTO analytics.luggage_inspection
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
    now() - random() * INTERVAL '1000 hours',
    (ARRAY['CLEAR','CONFISCATED','WARNING'])[floor(random()*3+1)],
    random()*100,
    (random()*10)::int,
    CASE WHEN random() < 0.2 THEN NULL
         ELSE ARRAY['knife','liquid','battery']
        END,
    CASE WHEN random() < 0.15 THEN NULL
         ELSE 'Inspection note ' || md5(random()::text)
        END,
    random() * INTERVAL '6 minutes',
    jsonb_build_object('scanner_version', 'v' || (random()*3)::int)
FROM items.luggage l;



INSERT INTO analytics.criminal_screening
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
    b.id,
    now() - random() * INTERVAL '2000 hours',
    random() < 0.1,
    CASE WHEN random() < 0.1 THEN (random()*5)::int END,
    NULL,
    random()*10,
    point(random()*100, random()*100),
    tsrange(
            (now() - interval '1 day')::timestamp,
            now()::timestamp
    ),
    jsonb_build_object('engine','v2')
FROM identity.biometry b;


INSERT INTO analytics.passenger_profile
(
    passport_id,
    frequent_traveler,
    total_crossings,
    preferred_direction,
    average_risk,
    profile_notes,
    tags,
    risk_distribution,
    active_period
)
SELECT
    p.id,
    random() < 0.2,
    (random()*200)::int,
    (ARRAY['IN','OUT'])[floor(random()*2+1)],
    random()*5,
    CASE WHEN random() < 0.15 THEN NULL
         ELSE 'Profile ' || md5(random()::text)
        END,
    ARRAY['vip','monitor'],
    jsonb_build_object('risk_trend','stable'),
    daterange(CURRENT_DATE - 100, CURRENT_DATE + 100)
FROM identity.passport p;