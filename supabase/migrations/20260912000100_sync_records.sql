create table if not exists public.sync_records (
  user_id uuid not null,
  entity_table text not null,
  entity_id bigint not null,
  operation text not null,
  payload jsonb not null,
  updated_at timestamptz not null,
  created_at timestamptz not null default timezone('utc', now()),
  primary key (user_id, entity_table, entity_id)
);

create index if not exists sync_records_updated_at_idx
  on public.sync_records (user_id, updated_at);

alter table public.sync_records enable row level security;
