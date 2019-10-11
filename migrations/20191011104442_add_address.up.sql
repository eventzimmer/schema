--- add address field
ALTER TABLE eventzimmer.locations ADD COLUMN IF NOT EXISTS address text;
