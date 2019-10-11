--- drop function and revoke grants
DROP FUNCTION eventzimmer.accept_event;
DROP DOMAIN non_empty_varchar;

REVOKE SELECT, INSERT ON eventzimmer.proposed_events FROM aggregator;
