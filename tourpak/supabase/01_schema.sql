-- ============================================================
-- TourPak V1 — Supabase Schema
-- Run this in the Supabase SQL Editor
-- ============================================================

-- 1. DESTINATIONS
CREATE TABLE destinations (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name            text NOT NULL,
  province        text,
  description     text,
  hero_image_url  text,
  video_loop_url  text,
  latitude        decimal,
  longitude       decimal,
  best_months     text[],
  road_status     text CHECK (road_status IN ('green', 'yellow', 'red')),
  road_status_note text,
  road_updated_at timestamptz,
  is_featured     boolean DEFAULT false,
  created_at      timestamptz DEFAULT now()
);

COMMENT ON TABLE destinations IS 'Major travel destinations across Pakistan';
COMMENT ON COLUMN destinations.road_status IS 'green = clear, yellow = caution, red = closed';


-- 2. TOURIST SPOTS
CREATE TABLE tourist_spots (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  destination_id  uuid NOT NULL REFERENCES destinations(id) ON DELETE CASCADE,
  name            text NOT NULL,
  description     text,
  category        text CHECK (category IN ('lake', 'mountain', 'valley', 'heritage', 'camping')),
  hero_image_url  text,
  gallery_urls    text[],
  latitude        decimal,
  longitude       decimal,
  altitude_meters int,
  entry_fee       text,
  visiting_hours  text,
  best_months     text[],
  created_at      timestamptz DEFAULT now()
);

COMMENT ON TABLE tourist_spots IS 'Individual tourist spots within a destination';

CREATE INDEX idx_tourist_spots_destination ON tourist_spots(destination_id);
CREATE INDEX idx_tourist_spots_category ON tourist_spots(category);


-- 3. RESTAURANTS
CREATE TABLE restaurants (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  destination_id  uuid NOT NULL REFERENCES destinations(id) ON DELETE CASCADE,
  name            text NOT NULL,
  description     text,
  cuisine_type    text,
  price_range     text CHECK (price_range IN ('budget', 'mid', 'high')),
  image_url       text,
  phone           text,
  address         text,
  latitude        decimal,
  longitude       decimal,
  is_featured     boolean DEFAULT false,
  created_at      timestamptz DEFAULT now()
);

COMMENT ON TABLE restaurants IS 'Restaurants and eateries near destinations';

CREATE INDEX idx_restaurants_destination ON restaurants(destination_id);
CREATE INDEX idx_restaurants_price ON restaurants(price_range);


-- 4. GUIDES
CREATE TABLE guides (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  destination_id    uuid NOT NULL REFERENCES destinations(id) ON DELETE CASCADE,
  name              text NOT NULL,
  bio               text,
  profile_image_url text,
  languages         text[],
  specialties       text[],
  experience_years  int,
  price_per_day     int,
  phone             text,
  whatsapp          text,
  is_verified       boolean DEFAULT false,
  rating            decimal DEFAULT 0,
  total_reviews     int DEFAULT 0,
  created_at        timestamptz DEFAULT now()
);

COMMENT ON TABLE guides IS 'Local tour guides available for hire';

CREATE INDEX idx_guides_destination ON guides(destination_id);
CREATE INDEX idx_guides_verified ON guides(is_verified);


-- 5. EMERGENCY CONTACTS
CREATE TABLE emergency_contacts (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  destination_id  uuid NOT NULL REFERENCES destinations(id) ON DELETE CASCADE,
  type            text NOT NULL CHECK (type IN ('hospital', 'pharmacy', 'rescue', 'police', 'ptdc')),
  name            text NOT NULL,
  phone           text,
  address         text,
  latitude        decimal,
  longitude       decimal,
  is_open_24h     boolean DEFAULT false,
  created_at      timestamptz DEFAULT now()
);

COMMENT ON TABLE emergency_contacts IS 'Emergency services and contacts per destination';

CREATE INDEX idx_emergency_destination ON emergency_contacts(destination_id);
CREATE INDEX idx_emergency_type ON emergency_contacts(type);
