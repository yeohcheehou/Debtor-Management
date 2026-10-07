-- Run this once in Supabase: SQL Editor -> New query -> paste -> Run.

-- One row per user holding all invoices and collections.
create table if not exists public.app_data (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null default '{"invoices":[],"collections":[]}',
  version    integer not null default 1,
  updated_at timestamptz not null default now()
);

alter table public.app_data enable row level security;

-- A signed-in user can only see and change their own row.
create policy "own row" on public.app_data
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Private bucket for the PDF invoices (files live under <user id>/<invoice id>.pdf).
insert into storage.buckets (id, name, public)
values ('pdfs', 'pdfs', false)
on conflict (id) do nothing;

create policy "own pdfs select" on storage.objects for select to authenticated
  using (bucket_id = 'pdfs' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "own pdfs insert" on storage.objects for insert to authenticated
  with check (bucket_id = 'pdfs' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "own pdfs update" on storage.objects for update to authenticated
  using (bucket_id = 'pdfs' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "own pdfs delete" on storage.objects for delete to authenticated
  using (bucket_id = 'pdfs' and (storage.foldername(name))[1] = auth.uid()::text);
