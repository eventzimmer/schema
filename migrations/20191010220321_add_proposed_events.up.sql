--- create a table that will hold all proposed events
CREATE TABLE IF NOT EXISTS eventzimmer.proposed_events (
    location varchar NOT NULL
) INHERITS (eventzimmer.events);

COMMENT ON TABLE eventzimmer.proposed_events IS 'Proposed events can be submitted without a valid reference to a location.';

--- specify that input arguments must contain text
CREATE DOMAIN non_empty_varchar AS varchar CHECK(length(VALUE) > 0);

--- create function which moves a proposed event to an event
CREATE FUNCTION eventzimmer.accept_event(url non_empty_varchar, location non_empty_varchar) RETURNS void AS $$
DECLARE
    event eventzimmer.events;
BEGIN
    --- check if user has rights to use the location
    IF NOT accept_event.location IN (SELECT locations.name FROM protected.locations_owners AS locations WHERE locations.sub = (SELECT current_setting('request.jwt.claim.sub', true))) THEN
        RAISE EXCEPTION '% has no permission to use location %.', (SELECT current_setting('request.jwt.claim.sub', true)), location;
    END IF;
    --- select proposed event from table if exists
    IF NOT (SELECT EXISTS (SELECT proposed_events.url FROM eventzimmer.proposed_events AS proposed_events WHERE proposed_events.url = accept_event.url)) THEN
        RAISE EXCEPTION 'Proposed event with url % does not exist.', url;
    ELSE
        SELECT proposed_events.* FROM eventzimmer.proposed_events AS proposed_events WHERE proposed_events.url = accept_event.url INTO event;
    END IF;
    RAISE LOG 'Moving event with url % from proposed_events to events.', event.url;
    --- add location to event
    event.location = accept_event.location;
    --- remove proposed event
    DELETE FROM eventzimmer.proposed_events AS proposed_events WHERE proposed_events.name = event.name;
    --- add event to list of official events
    INSERT INTO eventzimmer.events SELECT event.*;
END;
$$ 
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = eventzimmer, protected, pg_temp;

COMMENT ON FUNCTION eventzimmer.accept_event IS 'Moves an event from proposed events to events.';

--- add grants
GRANT SELECT, INSERT ON eventzimmer.proposed_events TO aggregator;

GRANT EXECUTE ON FUNCTION eventzimmer.accept_event TO organizer;
