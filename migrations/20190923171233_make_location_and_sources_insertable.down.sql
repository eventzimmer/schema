--- revoke privileges and organizer role
REVOKE ALL ON eventzimmer.locations, eventzimmer.sources FROM organizer;
REVOKE ALL ON protected.locations_owners, protected.sources_owners FROM organizer;

REVOKE USAGE ON SCHEMA eventzimmer, protected FROM organizer;

--- drop trigger and function for location owners

DROP TRIGGER location_inserted ON eventzimmer.locations;
DROP FUNCTION protected.add_location_owner;

--- drop trigger and function for source owners
DROP TRIGGER source_inserted ON eventzimmer.sources;
DROP FUNCTION protected.add_source_owner;

--- delete unused role

DROP ROLE organizer;
