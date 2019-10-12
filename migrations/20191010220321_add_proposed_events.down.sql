--- drop function and revoke grants, then drop view
DROP FUNCTION eventzimmer.accept_event;
DROP DOMAIN non_empty_varchar;

REVOKE SELECT ON eventzimmer.proposed_events_by_organizer FROM organizer;
REVOKE SELECT, INSERT ON eventzimmer.proposed_events FROM aggregator;

DROP VIEW eventzimmer.proposed_events_by_organizer;
