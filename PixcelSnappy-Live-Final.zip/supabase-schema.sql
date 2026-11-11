-- PIXELSNAPPY production gallery schema
-- Run this entire script in Supabase Dashboard > SQL Editor.

create table if not exists public.gallery_items (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  title text not null default 'Untitled frame',
  category text not null default 'other' check (category in ('wedding','bridal','editorial','other')),
  image_url text not null,
  storage_path text,
  alt_text text not null default '',
  published boolean not null default true,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.gallery_items add column if not exists media_type text not null default 'image' check (media_type in ('image','video'));

create index if not exists gallery_items_public_idx
  on public.gallery_items (published, category, sort_order, created_at desc);

alter table public.gallery_items enable row level security;

drop policy if exists "Public can view published gallery items" on public.gallery_items;
create policy "Public can view published gallery items"
  on public.gallery_items for select
  using (published = true);

drop policy if exists "Owners can view their gallery items" on public.gallery_items;
create policy "Owners can view their gallery items"
  on public.gallery_items for select to authenticated
  using (auth.uid() = owner_id);

drop policy if exists "Owners can insert gallery items" on public.gallery_items;
create policy "Owners can insert gallery items"
  on public.gallery_items for insert to authenticated
  with check (auth.uid() = owner_id);

drop policy if exists "Owners can update gallery items" on public.gallery_items;
create policy "Owners can update gallery items"
  on public.gallery_items for update to authenticated
  using (auth.uid() = owner_id) with check (auth.uid() = owner_id);

drop policy if exists "Owners can delete gallery items" on public.gallery_items;
create policy "Owners can delete gallery items"
  on public.gallery_items for delete to authenticated
  using (auth.uid() = owner_id);

create or replace function public.set_gallery_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end;
$$;
drop trigger if exists gallery_items_updated_at on public.gallery_items;
create trigger gallery_items_updated_at before update on public.gallery_items
for each row execute function public.set_gallery_updated_at();

-- Create a PUBLIC bucket so visitors can view portfolio images.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('portfolio', 'portfolio', true, 15728640,
  array['image/jpeg','image/png','image/webp','image/avif'])
on conflict (id) do update set public = true, file_size_limit = 15728640,
  allowed_mime_types = array['image/jpeg','image/png','image/webp','image/avif'];

-- Signed-in studio owner may upload only inside their own UUID folder.
drop policy if exists "Studio owners upload portfolio images" on storage.objects;
create policy "Studio owners upload portfolio images" on storage.objects
for insert to authenticated with check (
  bucket_id = 'portfolio' and (storage.foldername(name))[1] = auth.uid()::text
);
drop policy if exists "Studio owners update portfolio images" on storage.objects;
create policy "Studio owners update portfolio images" on storage.objects
for update to authenticated using (
  bucket_id = 'portfolio' and (storage.foldername(name))[1] = auth.uid()::text
) with check (
  bucket_id = 'portfolio' and (storage.foldername(name))[1] = auth.uid()::text
);
drop policy if exists "Studio owners delete portfolio images" on storage.objects;
create policy "Studio owners delete portfolio images" on storage.objects
for delete to authenticated using (
  bucket_id = 'portfolio' and (storage.foldername(name))[1] = auth.uid()::text
);

-- Explicit table grants for the browser roles used by Supabase.
grant select on public.gallery_items to anon;
grant select, insert, update, delete on public.gallery_items to authenticated;


-- Separate public bucket for published portfolio films (MP4 / WebM).
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('films', 'films', true, 104857600, array['video/mp4','video/webm'])
on conflict (id) do update set public = true, file_size_limit = 104857600,
  allowed_mime_types = array['video/mp4','video/webm'];

drop policy if exists "Studio owners upload portfolio films" on storage.objects;
create policy "Studio owners upload portfolio films" on storage.objects
for insert to authenticated with check (
  bucket_id = 'films' and (storage.foldername(name))[1] = auth.uid()::text
);
drop policy if exists "Studio owners update portfolio films" on storage.objects;
create policy "Studio owners update portfolio films" on storage.objects
for update to authenticated using (
  bucket_id = 'films' and (storage.foldername(name))[1] = auth.uid()::text
) with check (
  bucket_id = 'films' and (storage.foldername(name))[1] = auth.uid()::text
);
drop policy if exists "Studio owners delete portfolio films" on storage.objects;
create policy "Studio owners delete portfolio films" on storage.objects
for delete to authenticated using (
  bucket_id = 'films' and (storage.foldername(name))[1] = auth.uid()::text
);
