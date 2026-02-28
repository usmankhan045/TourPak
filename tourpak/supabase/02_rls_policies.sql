-- ============================================================
-- TourPak V1 — Row Level Security Policies
-- Run this AFTER 01_schema.sql
-- ============================================================

-- ── DESTINATIONS ──────────────────────────────────────────
ALTER TABLE destinations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "destinations_public_read"
  ON destinations FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "destinations_auth_insert"
  ON destinations FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "destinations_auth_update"
  ON destinations FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "destinations_auth_delete"
  ON destinations FOR DELETE
  TO authenticated
  USING (true);


-- ── TOURIST SPOTS ─────────────────────────────────────────
ALTER TABLE tourist_spots ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tourist_spots_public_read"
  ON tourist_spots FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "tourist_spots_auth_insert"
  ON tourist_spots FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "tourist_spots_auth_update"
  ON tourist_spots FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "tourist_spots_auth_delete"
  ON tourist_spots FOR DELETE
  TO authenticated
  USING (true);


-- ── RESTAURANTS ───────────────────────────────────────────
ALTER TABLE restaurants ENABLE ROW LEVEL SECURITY;

CREATE POLICY "restaurants_public_read"
  ON restaurants FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "restaurants_auth_insert"
  ON restaurants FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "restaurants_auth_update"
  ON restaurants FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "restaurants_auth_delete"
  ON restaurants FOR DELETE
  TO authenticated
  USING (true);


-- ── GUIDES ────────────────────────────────────────────────
ALTER TABLE guides ENABLE ROW LEVEL SECURITY;

CREATE POLICY "guides_public_read"
  ON guides FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "guides_auth_insert"
  ON guides FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "guides_auth_update"
  ON guides FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "guides_auth_delete"
  ON guides FOR DELETE
  TO authenticated
  USING (true);


-- ── EMERGENCY CONTACTS ────────────────────────────────────
ALTER TABLE emergency_contacts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "emergency_contacts_public_read"
  ON emergency_contacts FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "emergency_contacts_auth_insert"
  ON emergency_contacts FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "emergency_contacts_auth_update"
  ON emergency_contacts FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "emergency_contacts_auth_delete"
  ON emergency_contacts FOR DELETE
  TO authenticated
  USING (true);
