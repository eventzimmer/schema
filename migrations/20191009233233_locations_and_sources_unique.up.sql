--- add unique index on location
CREATE UNIQUE INDEX unique_location ON eventzimmer.locations(lower(name));

--- add unique index on source
CREATE UNIQUE INDEX unique_source ON eventzimmer.sources(lower(url));

--- add cascade to source foreign key
BEGIN;
ALTER TABLE eventzimmer.events
DROP CONSTRAINT events_source_fkey;

ALTER TABLE eventzimmer.events
ADD CONSTRAINT events_source_fkey
FOREIGN KEY (source)
REFERENCES eventzimmer.sources(url)
ON DELETE CASCADE;

COMMIT;

--- add cascade to location foreign key
BEGIN;
ALTER TABLE eventzimmer.events
DROP CONSTRAINT events_location_fkey;

ALTER TABLE eventzimmer.events
ADD CONSTRAINT events_location_fkey
FOREIGN KEY (location)
REFERENCES eventzimmer.locations(name)
ON DELETE CASCADE;

COMMIT;
