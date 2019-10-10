--- revoke grants
REVOKE SELECT ON eventzimmer.sources_by_owner FROM organizer;
REVOKE SELECT ON eventzimmer.locations_by_owner FROM organizer;

--- drop views
DROP VIEW eventzimmer.sources_by_owner;
DROP VIEW eventzimmer.locations_by_owner;
