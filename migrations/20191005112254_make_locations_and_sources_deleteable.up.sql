--- add location delete policy
CREATE POLICY location_delete ON eventzimmer.locations FOR DELETE TO organizer USING(
    (SELECT EXISTS (SELECT name FROM protected.locations_owners AS owners WHERE owners.name = locations.name AND owners.sub = (SELECT current_setting('request.jwt.claim.sub', true))))
);

--- add source delete policy
CREATE POLICY source_delete ON eventzimmer.sources FOR DELETE USING(
    (SELECT EXISTS (SELECT url FROM protected.sources_owners AS owners WHERE owners.url = sources.url AND owners.sub = (SELECT current_setting('request.jwt.claim.sub', true))))
);

--- enable row level security
ALTER TABLE eventzimmer.locations ENABLE ROW LEVEL SECURITY;

GRANT DELETE ON eventzimmer.locations TO organizer;
GRANT DELETE ON eventzimmer.sources TO organizer;

CREATE POLICY location_select ON eventzimmer.locations FOR SELECT USING (true);
CREATE POLICY location_insert ON eventzimmer.locations FOR INSERT TO organizer WITH CHECK (true);

ALTER TABLE eventzimmer.sources ENABLE ROW LEVEL SECURITY;

CREATE POLICY source_select ON eventzimmer.sources FOR SELECT USING (true);
CREATE POLICY source_insert ON eventzimmer.sources FOR INSERT TO organizer WITH CHECK (true);


GRANT DELETE ON eventzimmer.locations TO organizer;
GRANT DELETE ON eventzimmer.sources TO organizer;
