create table if not exists public.user_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  display_name text,
  weekly_budget_cents bigint not null default 0,
  active_days text not null default '1,2,3,4,5,6,7',
  meals_per_day integer not null default 3,
  weight_kg numeric,
  height_cm numeric,
  age integer,
  sex text,
  activity_level text not null default 'moderate',
  goal_preset text not null default 'balanced',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.dishes (
  user_id uuid not null references auth.users(id) on delete cascade,
  local_id bigint not null,
  name text not null,
  price_cents bigint not null,
  cuisine_tag text,
  photo_path text,
  source text not null default 'manual',
  created_at timestamptz not null,
  updated_at timestamptz not null,
  is_deleted boolean not null default false,
  primary key (user_id, local_id)
);

create table if not exists public.ingredients (
  user_id uuid not null,
  dish_local_id bigint not null,
  local_id bigint not null,
  name text not null,
  quantity numeric not null default 1,
  unit text not null default 'serving',
  calories numeric not null default 0,
  protein_g numeric not null default 0,
  carbs_g numeric not null default 0,
  fat_g numeric not null default 0,
  micronutrients_json jsonb,
  usda_fdc_id bigint,
  is_cached_from_api boolean not null default false,
  primary key (user_id, local_id),
  foreign key (user_id, dish_local_id)
    references public.dishes(user_id, local_id) on delete cascade
);

create table if not exists public.nutrition_caches (
  name text primary key,
  calories numeric not null,
  protein_g numeric not null,
  carbs_g numeric not null,
  fat_g numeric not null,
  usda_fdc_id bigint,
  cached_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.allergen_tags (
  user_id uuid not null references auth.users(id) on delete cascade,
  local_id bigint not null,
  label text not null,
  primary key (user_id, local_id)
);

create table if not exists public.dish_allergen_tags (
  user_id uuid not null,
  dish_local_id bigint not null,
  allergen_local_id bigint not null,
  primary key (user_id, dish_local_id, allergen_local_id),
  foreign key (user_id, dish_local_id)
    references public.dishes(user_id, local_id) on delete cascade,
  foreign key (user_id, allergen_local_id)
    references public.allergen_tags(user_id, local_id) on delete cascade
);

create table if not exists public.generated_plans (
  user_id uuid not null references auth.users(id) on delete cascade,
  local_id bigint not null,
  week_start_date date not null,
  generated_at timestamptz not null,
  total_projected_cost_cents bigint not null,
  is_over_budget boolean not null default false,
  version integer not null,
  primary key (user_id, local_id)
);

create table if not exists public.meal_slots (
  user_id uuid not null,
  local_id bigint not null,
  generated_plan_local_id bigint not null,
  dish_local_id bigint not null,
  day_index integer not null,
  slot_index integer not null,
  planned_cost_cents bigint not null,
  planned_calories numeric not null default 0,
  primary key (user_id, local_id),
  foreign key (user_id, generated_plan_local_id)
    references public.generated_plans(user_id, local_id) on delete cascade,
  foreign key (user_id, dish_local_id)
    references public.dishes(user_id, local_id)
);

create table if not exists public.budget_entries (
  user_id uuid not null references auth.users(id) on delete cascade,
  local_id bigint not null,
  generated_plan_local_id bigint,
  amount_cents bigint not null,
  label text not null,
  occurred_at timestamptz not null,
  created_at timestamptz not null,
  primary key (user_id, local_id),
  foreign key (user_id, generated_plan_local_id)
    references public.generated_plans(user_id, local_id) on delete set null
);

create index if not exists dishes_owner_updated_idx
  on public.dishes (user_id, updated_at);
create index if not exists plans_owner_version_idx
  on public.generated_plans (user_id, version desc);
create index if not exists budget_owner_occurred_idx
  on public.budget_entries (user_id, occurred_at desc);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

drop trigger if exists user_profiles_set_updated_at on public.user_profiles;
create trigger user_profiles_set_updated_at
before update on public.user_profiles
for each row execute function public.set_updated_at();

drop trigger if exists dishes_set_updated_at on public.dishes;
create trigger dishes_set_updated_at
before update on public.dishes
for each row execute function public.set_updated_at();

create or replace function public.apply_sync_record(
  p_user_id uuid,
  p_entity_table text,
  p_entity_id bigint,
  p_operation text,
  p_payload jsonb,
  p_updated_at timestamptz
)
returns table(accepted boolean, conflict boolean)
language plpgsql
security definer
set search_path = public
as $$
declare
  current_updated_at timestamptz;
begin
  select updated_at into current_updated_at
  from public.sync_records
  where user_id = p_user_id
    and entity_table = p_entity_table
    and entity_id = p_entity_id
  for update;

  if current_updated_at is not null and current_updated_at > p_updated_at then
    return query select false, true;
    return;
  end if;

  insert into public.sync_records(
    user_id, entity_table, entity_id, operation, payload, updated_at
  ) values (
    p_user_id, p_entity_table, p_entity_id, p_operation, p_payload, p_updated_at
  )
  on conflict (user_id, entity_table, entity_id) do update set
    operation = excluded.operation,
    payload = excluded.payload,
    updated_at = excluded.updated_at;

  return query select true, false;
end;
$$;

revoke all on function public.apply_sync_record(uuid, text, bigint, text, jsonb, timestamptz)
  from public, authenticated;
grant execute on function public.apply_sync_record(uuid, text, bigint, text, jsonb, timestamptz)
  to service_role;

do $$
declare
  table_name text;
begin
  foreach table_name in array array[
    'user_profiles', 'dishes', 'ingredients', 'allergen_tags',
    'dish_allergen_tags', 'generated_plans', 'meal_slots', 'budget_entries'
  ] loop
    execute format('alter table public.%I enable row level security', table_name);
    execute format('drop policy if exists %I on public.%I', table_name || '_owner', table_name);
    execute format(
      'create policy %I on public.%I for all using (user_id = auth.uid()) with check (user_id = auth.uid())',
      table_name || '_owner', table_name
    );
  end loop;
end;
$$;

alter table public.nutrition_caches enable row level security;
drop policy if exists nutrition_caches_read on public.nutrition_caches;
create policy nutrition_caches_read on public.nutrition_caches
  for select to authenticated using (true);
