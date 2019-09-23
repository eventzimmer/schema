--- remove trigger and function
DROP TRIGGER location_inserted ON eventzimmer.locations;
DROP TRIGGER source_inserted ON eventzimmer.sources;

DROP FUNCTION protected.add_location_owner;
DROP FUNCTION protected.add_source_owner;

--- remove role organizer
REVOKE SELECT, INSERT ON protected.locations_owners FROM organizer;
REVOKE SELECT, INSERT ON protected.sources_owners FROM organizer;

REVOKE SELECT, INSERT ON eventzimmer.locations FROM organizer;
REVOKE SELECT, INSERT ON eventzimmer.sources FROM organizer;

REVOKE USAGE ON SCHEMA eventzimmer FROM organizer;
REVOKE USAGE ON SCHEMA protected FROM organizer;

DROP ROLE organizer;
