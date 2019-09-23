--- create owners for locations
CREATE TABLE IF NOT EXISTS protected.locations_owners (
    name varchar NOT NULL REFERENCES eventzimmer.locations(name) ON DELETE CASCADE,
    sub varchar NOT NULL
);

COMMENT ON TABLE protected.locations_owners IS 'Holds location owners';

--- create owners for sources
CREATE TABLE IF NOT EXISTS protected.sources_owners (
    url varchar NOT NULL REFERENCES eventzimmer.sources(url) ON DELETE CASCADE,
    sub varchar NOT NULL
);

COMMENT ON TABLE protected.sources_owners IS 'Holds sources owners';

--- create trigger for locations
CREATE FUNCTION protected.add_location_owner() RETURNS trigger AS $add_location_owner$
    BEGIN
        INSERT INTO protected.locations_owners(name, sub) VALUES (NEW.name, (SELECT current_setting('request.jwt.claim.sub', true)));     
        RETURN NEW;
    END;
$add_location_owner$ LANGUAGE plpgsql;

COMMENT ON FUNCTION protected.add_location_owner IS 'Add current token sub (user) to location owners';

CREATE TRIGGER location_inserted AFTER INSERT ON eventzimmer.locations FOR EACH ROW EXECUTE PROCEDURE protected.add_location_owner();

--- create trigger for source
CREATE FUNCTION protected.add_source_owner() RETURNS trigger AS $add_location_owner$
    BEGIN
        INSERT INTO protected.sources_owners(url, sub) VALUES (NEW.url, (SELECT current_setting('request.jwt.claim.sub', true)));     
        RETURN NEW;
    END;
$add_location_owner$ LANGUAGE plpgsql;

COMMENT ON FUNCTION protected.add_source_owner IS 'Add current token sub (user) to sources owners';

CREATE TRIGGER source_inserted AFTER INSERT ON eventzimmer.sources FOR EACH ROW EXECUTE PROCEDURE protected.add_source_owner();

--- create organizer role and grant permissions for insertion
CREATE ROLE organizer nologin;

GRANT USAGE ON SCHEMA eventzimmer TO organizer;
GRANT USAGE ON SCHEMA protected TO organizer;

GRANT SELECT, INSERT ON protected.locations_owners TO organizer;
GRANT SELECT, INSERT ON protected.sources_owners TO organizer;

GRANT EXECUTE ON FUNCTION protected.add_location_owner TO organizer;
GRANT EXECUTE ON FUNCTION protected.add_source_owner TO organizer;

GRANT SELECT, INSERT ON eventzimmer.locations TO organizer;
GRANT SELECT, INSERT ON eventzimmer.sources TO organizer;
