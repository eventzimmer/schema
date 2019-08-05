--- protected schema
CREATE SCHEMA protected;
COMMENT ON SCHEMA protected IS 'The schema for protected queries';

--- eventzimmer schema
CREATE SCHEMA eventzimmer;
COMMENT ON SCHEMA eventzimmer IS 'The schema for the eventzimmer event aggregation service';

-- aggregator type
CREATE TYPE eventzimmer.aggregator as ENUM ('Facebook', 'iCal');
COMMENT ON TYPE eventzimmer.aggregator IS 'Possible types of sources';

-- locations
CREATE TABLE eventzimmer.locations (
  name varchar PRIMARY KEY NOT NULL,
  latitude float NOT NULL,
  longitude float NOT NULL
);

COMMENT ON TABLE eventzimmer.locations IS 'The list of available locations';
COMMENT ON COLUMN eventzimmer.locations.name IS 'The name that the location is identified with';

-- sources
CREATE TABLE eventzimmer.sources (
  url varchar PRIMARY KEY NOT NULL,
  aggregator eventzimmer.aggregator NOT NULL
);

COMMENT ON TABLE eventzimmer.sources IS 'The list of available sources';

-- events
CREATE TABLE eventzimmer.events (
  name varchar NOT NULL,
  url varchar PRIMARY KEY NOT NULL,
  description text,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  starts_at TIMESTAMPTZ NOT NULL,
  source varchar NOT NULL REFERENCES eventzimmer.sources(url),
  location varchar NOT NULL REFERENCES eventzimmer.locations(name)
);

COMMENT ON TABLE eventzimmer.events IS 'The list of available events';
COMMENT ON COLUMN eventzimmer.events.name IS 'The name that the event will be displayed with';
COMMENT ON COLUMN eventzimmer.events.url IS 'The url that the event should be linked to. This can be an anchor or a fully qualified resource identifier.';

-- Use ST_Point to create a geometry for every latitude / longitude in the locations table.
CREATE VIEW protected.locations_geom AS SELECT
  name,
  (SELECT CAST(ST_SetSRID(ST_Point(longitude, latitude), 4326) AS GEOGRAPHY)) AS geom
FROM eventzimmer.locations;

COMMENT ON VIEW protected.locations_geom IS 'The list of geometries for locations';

-- Events no older than 3 hours up to 60 days
CREATE VIEW protected.recent_events AS SELECT * FROM eventzimmer.events WHERE starts_at >= current_timestamp - interval '3 hours' AND starts_at <= current_timestamp + interval '60 days';

COMMENT ON VIEW protected.recent_events IS 'Recent events';

-- Specify that radius must be positive and no larger than 25000 meters.
CREATE DOMAIN radius AS integer CHECK(VALUE > 0 AND VALUE <= 25000);

-- Function for filtering events by latitude / longitude
CREATE FUNCTION eventzimmer.events_by_radius(latitude float, longitude float, radius radius default 15000) RETURNS SETOF eventzimmer.events
    AS $$
    SELECT * FROM protected.recent_events WHERE location IN 
    (SELECT name FROM protected.locations_geom WHERE ST_DWithin(
      geom,
      (SELECT CAST(ST_SetSRID(ST_Point(longitude, latitude), 4326) AS GEOGRAPHY)),
      radius
    ))
$$ LANGUAGE SQL STABLE;

COMMENT ON FUNCTION eventzimmer.events_by_radius IS 'Filters event by radius';

-- Permission systems
CREATE ROLE web_anon nologin;
CREATE ROLE aggregator nologin;

GRANT USAGE ON SCHEMA eventzimmer TO web_anon, aggregator;
GRANT USAGE ON SCHEMA protected TO web_anon;

GRANT SELECT ON eventzimmer.events TO web_anon;
GRANT SELECT ON eventzimmer.sources TO web_anon;
GRANT SELECT ON eventzimmer.locations TO web_anon;
GRANT EXECUTE ON FUNCTION eventzimmer.events_by_radius TO web_anon;

GRANT SELECT ON protected.locations_geom TO web_anon;
GRANT SELECT ON protected.recent_events TO web_anon;

GRANT INSERT ON eventzimmer.events TO aggregator;
GRANT SELECT ON eventzimmer.events TO aggregator;
