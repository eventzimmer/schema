--- add view for locations
CREATE VIEW eventzimmer.locations_by_owner AS 
    SELECT * FROM eventzimmer.locations AS locations 
    WHERE locations.name IN (SELECT owners.name FROM protected.locations_owners AS owners WHERE owners.sub = (SELECT current_setting('request.jwt.claim.sub', true)));

COMMENT ON VIEW eventzimmer.locations_by_owner IS 'Returns all locations owned by the current user.';

--- add view for sources
CREATE VIEW eventzimmer.sources_by_owner AS
    SELECT * FROM eventzimmer.sources AS sources
    WHERE sources.url IN (SELECT owners.url FROM protected.sources_owners AS owners WHERE owners.sub = (SELECT current_setting('request.jwt.claim.sub', true)));

COMMENT ON VIEW eventzimmer.sources_by_owner IS 'Returns all sources owned by the current user.';

--- add grants
GRANT SELECT ON eventzimmer.locations_by_owner TO organizer;
GRANT SELECT ON eventzimmer.sources_by_owner TO organizer;
