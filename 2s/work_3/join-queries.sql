EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    bc.crossing_time, 
    bc.checkpoint_code, 
    p.fullName, 
    c.name as country_name
FROM analytics.border_crossing bc
JOIN identity.passport p ON bc.passport_id = p.id
JOIN identity.country c ON p.country = c.id
WHERE bc.direction = 'IN';

EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    li.inspection_time, 
    li.result, 
    lit.itemName, 
    COUNT(litem.id) as item_count
FROM analytics.luggage_inspection li
JOIN items.luggage l ON li.luggage_id = l.id
JOIN items.luggageitem litem ON l.id = litem.luggage_id
JOIN items.luggageitemtype lit ON litem.itemtype_id = lit.id
GROUP BY li.id, lit.itemName;

EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    cs.screening_time, 
    cs.threat_level, 
    c.caseType_id, 
    ct.description as case_description
FROM analytics.criminal_screening cs
JOIN criminal.record cr ON cs.biometry_id = cr.biometryId
JOIN criminal.case c ON cr.crimeId = c.id
JOIN criminal.casetype ct ON c.caseType_id = ct.id
WHERE cs.match_found = true;

EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    pp.passport_id, 
    pp.total_crossings as profile_count, 
    COUNT(bc.id) as actual_count
FROM analytics.passenger_profile pp
LEFT JOIN analytics.border_crossing bc ON pp.passport_id = bc.passport_id
GROUP BY pp.id, pp.total_crossings
HAVING pp.total_crossings != COUNT(bc.id);

EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    bc.crossing_time, 
    p.fullName, 
    wp.activityId, 
    wp.validUntil as work_permission_validity
FROM analytics.border_crossing bc
JOIN identity.passport p ON bc.passport_id = p.id
JOIN people.entrant e ON p.id = e.passportId
JOIN papers.workpermission wp ON e.workPermissionId = wp.id
WHERE bc.direction = 'IN' 
  AND wp.validUntil < CURRENT_DATE;