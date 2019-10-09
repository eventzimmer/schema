--- add unique index on location
CREATE UNIQUE INDEX unique_location ON eventzimmer.locations(lower(name));

--- add unique index on source
CREATE UNIQUE INDEX unique_source ON eventzimmer.sources(lower(url));
