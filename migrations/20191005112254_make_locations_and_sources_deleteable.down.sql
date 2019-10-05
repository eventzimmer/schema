--- clean up policies and disable row level security
REVOKE DELETE ON eventzimmer.locations FROM organizer;
REVOKE DELETE ON eventzimmer.sources FROM organizer;

DROP POLICY location_delete ON eventzimmer.locations;
DROP POLICY source_delete ON eventzimmer.sources;

ALTER TABLE eventzimmer.locations DISABLE ROW LEVEL SECURITY;
DROP POLICY location_select ON eventzimmer.locations;
DROP POLICY location_insert ON eventzimmer.locations;

ALTER TABLE eventzimmer.sources DISABLE ROW LEVEL SECURITY;
DROP POLICY source_select ON eventzimmer.sources;
DROP POLICY source_insert ON eventzimmer.sources;
