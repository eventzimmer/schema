--- values in enum types cannot be dropped
--- no backward migration is possible
ALTER TYPE eventzimmer.aggregator ADD VALUE IF NOT EXISTS 'RSS';
