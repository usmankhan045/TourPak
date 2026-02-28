-- ============================================================
-- TourPak V1 — Storage Buckets
-- Run this AFTER 02_rls_policies.sql
-- ============================================================

-- Create public storage buckets
INSERT INTO storage.buckets (id, name, public)
VALUES
  ('destination-images', 'destination-images', true),
  ('spot-images', 'spot-images', true),
  ('guide-photos', 'guide-photos', true);


-- ── PUBLIC READ for all buckets ───────────────────────────

-- destination-images: anyone can view
CREATE POLICY "destination_images_public_read"
  ON storage.objects FOR SELECT
  TO anon, authenticated
  USING (bucket_id = 'destination-images');

-- destination-images: authenticated can upload
CREATE POLICY "destination_images_auth_upload"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'destination-images');

-- destination-images: authenticated can update
CREATE POLICY "destination_images_auth_update"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (bucket_id = 'destination-images');

-- destination-images: authenticated can delete
CREATE POLICY "destination_images_auth_delete"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'destination-images');


-- spot-images: anyone can view
CREATE POLICY "spot_images_public_read"
  ON storage.objects FOR SELECT
  TO anon, authenticated
  USING (bucket_id = 'spot-images');

-- spot-images: authenticated can upload
CREATE POLICY "spot_images_auth_upload"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'spot-images');

-- spot-images: authenticated can update
CREATE POLICY "spot_images_auth_update"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (bucket_id = 'spot-images');

-- spot-images: authenticated can delete
CREATE POLICY "spot_images_auth_delete"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'spot-images');


-- guide-photos: anyone can view
CREATE POLICY "guide_photos_public_read"
  ON storage.objects FOR SELECT
  TO anon, authenticated
  USING (bucket_id = 'guide-photos');

-- guide-photos: authenticated can upload
CREATE POLICY "guide_photos_auth_upload"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'guide-photos');

-- guide-photos: authenticated can update
CREATE POLICY "guide_photos_auth_update"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (bucket_id = 'guide-photos');

-- guide-photos: authenticated can delete
CREATE POLICY "guide_photos_auth_delete"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'guide-photos');
