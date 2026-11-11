PIXELSNAPPY — ROYAL MOTION / CLOUD PORTFOLIO
================================================

WHAT IS INCLUDED
- Royal editorial visual direction: warm ivory, champagne gold, deep charcoal and wine accents.
- Animated hero reveal, gentle parallax, elegant hover motion, scroll reveals and cinematic film feature panel.
- Responsive photography portfolio with 39 supplied starter photographs.
- Separate Other Shoots collection, gallery filters and full-screen lightbox.
- Secure Supabase studio login and cloud content manager.
- Upload multiple photographs AND MP4/WebM films, edit captions and alt text, categorise, publish/unpublish and delete.
- Photos and films are stored in separate public buckets; public visitors only see published gallery records.
- Reduced-motion accessibility support.

1. PREVIEW LOCALLY
1. Extract this ZIP.
2. Open the PixelSnappy_Premium_Client folder in VS Code.
3. Install the Live Server extension if needed.
4. Right-click index.html > Open with Live Server.
5. The public website opens. Local starter photographs are visible without Supabase.
6. Studio Manager is admin.html. Cloud sign-in requires Supabase configuration.

2. CONNECT SUPABASE
1. Create a Supabase project owned by the client/business at https://supabase.com.
2. Open Project Settings > API / API Keys.
3. Copy the Project URL and public anon/publishable key.
4. Open supabase-schema.sql in VS Code. Copy the complete file into Supabase > SQL Editor > New Query and Run.
   This creates the gallery table, RLS policies, image bucket (portfolio) and film bucket (films).
   If an earlier version of the schema was already run, run this updated script again to add media_type and the films bucket.
5. In Supabase > Authentication > Users, create the studio owner's email/password.
6. Keep public sign-ups disabled unless deliberately required.
7. Open config.js and replace:
   https://YOUR-PROJECT.supabase.co
   YOUR_SUPABASE_ANON_OR_PUBLISHABLE_KEY
   with the client's Project URL and public anon/publishable key.
8. Never place service_role/secret keys or database passwords in browser code.

3. IMPORT THE STARTER PHOTOGRAPHS
1. Run Live Server and visit /admin.html.
2. Sign in with the studio owner's Supabase email/password.
3. Click Import starter portfolio once. Wait for completion.
4. It imports the 39 included photos to the portfolio bucket. Do not repeat if already imported.

4. ADD NEW PHOTOGRAPHS AND VIDEOS
1. In Studio Manager, choose photos or videos.
2. Select a collection and enter a caption prefix if desired.
3. Choose Publish immediately or Save as draft.
4. Click Upload to cloud. Photos are optimised to JPEG; video files are uploaded as provided.
5. Supported images: JPEG, PNG, WebP, AVIF, maximum 15 MB each.
6. Supported videos: MP4 and WebM, maximum 100 MB each.
7. Published videos appear as playable video cards in the portfolio and open in the full-screen viewer.
8. Edit title/description/category or publish status in the library. Delete removes the database record and the corresponding storage object.

5. DEPLOY ONLINE
1. The client should own the domain, Supabase project and hosting account.
2. Deploy the contents of PixelSnappy_Premium_Client as the site root using Netlify, Vercel or Cloudflare Pages. index.html must be at the root.
3. In Supabase Authentication > URL Configuration, set the production Site URL to the live HTTPS domain and add any required redirect URL.
4. Test the public site and /admin.html on desktop and mobile.
5. Sign in as the client and upload a test image and MP4/WebM video. Confirm published media appears publicly; drafts remain hidden.
6. Verify delete, edit and unpublish actions before handover.

SECURITY / PRODUCTION NOTES
- The portfolio buckets are public so portfolio media can be viewed by website visitors. Never store private client proofs in these buckets.
- Gallery metadata is protected by Row Level Security. Owners can manage only rows belonging to their authenticated user ID.
- Storage upload/update/delete policies restrict each owner's files to their own UUID folder.
- Only use the public anon/publishable key in config.js. Never expose service_role/secret keys.
- Public media URLs can be shared; that is intentional for a public portfolio.
- For large video libraries or higher traffic, consider a dedicated video CDN/streaming service. Supabase Storage provides file hosting, not adaptive video transcoding.
- Confirm client permission to publish every photo/video and retain original media backups.

TROUBLESHOOTING
- Connect Supabase first: config.js still has placeholder credentials.
- Invalid login: verify the studio user in the correct Supabase project.
- relation gallery_items does not exist: run the complete updated SQL script.
- Upload denied: confirm storage policies and that you are signed in as the correct owner.
- Film upload denied: confirm the films bucket and film policies exist.
- Video fails to play: use MP4 encoded with H.264/AAC or WebM; check browser compatibility and file size.
- Starter import fails: ensure all assets and gallery-manifest.json were deployed together.

FILES
index.html / styles.css / script.js — public site
admin.html / admin.css / admin.js — studio manager
config.js — public Supabase project URL and anon/publishable key
supabase-schema.sql — database and storage policies
gallery-manifest.json — 39 starter image records
assets/ — starter photography and PixelSnappy logo
