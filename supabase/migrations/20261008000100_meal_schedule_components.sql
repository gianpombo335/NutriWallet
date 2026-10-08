alter table public.user_profiles
  add column if not exists meal_times_json text not null default '[480,780,1140]';

create table if not exists public.meal_slot_items (
  user_id uuid not null references auth.users(id) on delete cascade,
  meal_slot_local_id bigint not null,
  sort_order integer not null,
  dish_local_id bigint not null,
  planned_cost_cents bigint not null,
  planned_calories numeric not null default 0,
  planned_protein_g numeric not null default 0,
  planned_carbs_g numeric not null default 0,
  planned_fat_g numeric not null default 0,
  servings numeric not null default 1,
  primary key (user_id, meal_slot_local_id, sort_order),
  foreign key (user_id, meal_slot_local_id)
    references public.meal_slots(user_id, local_id) on delete cascade,
  foreign key (user_id, dish_local_id)
    references public.dishes(user_id, local_id)
);

alter table public.meal_slot_items enable row level security;
drop policy if exists meal_slot_items_owner on public.meal_slot_items;
create policy meal_slot_items_owner on public.meal_slot_items
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

create or replace function public.apply_user_profile_schedule(
  p_user_id uuid,
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
  result_accepted boolean;
  result_conflict boolean;
begin
  select result.accepted, result.conflict
  into result_accepted, result_conflict
  from public.apply_sync_record(
    p_user_id,
    'UserProfiles',
    p_entity_id,
    p_operation,
    p_payload,
    p_updated_at
  ) result;

  if result_conflict or not result_accepted then
    return query select result_accepted, result_conflict;
    return;
  end if;

  update public.user_profiles
  set meal_times_json = coalesce(p_payload ->> 'meal_times_json', '[480,780,1140]')
  where user_id = p_user_id;

  return query select true, false;
end;
$$;

revoke all on function public.apply_user_profile_schedule(uuid, bigint, text, jsonb, timestamptz)
  from public, authenticated;
grant execute on function public.apply_user_profile_schedule(uuid, bigint, text, jsonb, timestamptz)
  to service_role;

create or replace function public.apply_meal_slot_components(
  p_user_id uuid,
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
  target_plan_local_id bigint;
  item jsonb;
  item_index integer := 0;
  item_dish_id bigint;
  item_servings numeric;
  total_cost_cents bigint;
begin
  if p_operation not in ('insert', 'update')
     or jsonb_typeof(p_payload -> 'components') <> 'array'
     or jsonb_array_length(p_payload -> 'components') < 1 then
    return query select false, false;
    return;
  end if;

  select updated_at into current_updated_at
  from public.sync_records
  where user_id = p_user_id
    and entity_table = 'MealSlots'
    and entity_id = p_entity_id
  for update;

  if current_updated_at is not null and current_updated_at > p_updated_at then
    return query select false, true;
    return;
  end if;

  select generated_plan_local_id into target_plan_local_id
  from public.meal_slots
  where user_id = p_user_id and local_id = p_entity_id
  for update;

  if target_plan_local_id is null then
    return query select false, false;
    return;
  end if;

  for item in select * from jsonb_array_elements(p_payload -> 'components') loop
    item_dish_id := (item ->> 'dish_id')::bigint;
    item_servings := coalesce((item ->> 'servings')::numeric, 1);
    if item_dish_id is null or item_servings < 0.5 or item_servings > 20
       or not exists (
         select 1 from public.dishes
         where user_id = p_user_id
           and local_id = item_dish_id
           and is_deleted = false
       ) then
      return query select false, false;
      return;
    end if;
  end loop;

  update public.meal_slots
  set dish_local_id = (p_payload ->> 'dish_id')::bigint,
      planned_cost_cents = coalesce((p_payload ->> 'planned_cost_cents')::bigint, 0),
      planned_calories = coalesce((p_payload ->> 'planned_calories')::numeric, 0),
      planned_protein_g = coalesce((p_payload ->> 'planned_protein_g')::numeric, 0),
      planned_carbs_g = coalesce((p_payload ->> 'planned_carbs_g')::numeric, 0),
      planned_fat_g = coalesce((p_payload ->> 'planned_fat_g')::numeric, 0),
      servings = coalesce((p_payload ->> 'servings')::numeric, 1),
      meal_status = coalesce(p_payload ->> 'meal_status', meal_status),
      actual_cost_cents = case
        when p_payload ? 'actual_cost_cents'
          then (p_payload ->> 'actual_cost_cents')::bigint
        else actual_cost_cents
      end,
      substitute_name = case
        when p_payload ? 'substitute_name'
          then p_payload ->> 'substitute_name'
        else substitute_name
      end,
      consumed_at = case
        when p_payload ? 'consumed_at'
          then (p_payload ->> 'consumed_at')::timestamptz
        else consumed_at
      end
  where user_id = p_user_id and local_id = p_entity_id;

  delete from public.meal_slot_items
  where user_id = p_user_id and meal_slot_local_id = p_entity_id;

  for item in select * from jsonb_array_elements(p_payload -> 'components') loop
    insert into public.meal_slot_items(
      user_id, meal_slot_local_id, sort_order, dish_local_id,
      planned_cost_cents, planned_calories, planned_protein_g,
      planned_carbs_g, planned_fat_g, servings
    ) values (
      p_user_id,
      p_entity_id,
      item_index,
      (item ->> 'dish_id')::bigint,
      coalesce((item ->> 'planned_cost_cents')::bigint, 0),
      coalesce((item ->> 'planned_calories')::numeric, 0),
      coalesce((item ->> 'planned_protein_g')::numeric, 0),
      coalesce((item ->> 'planned_carbs_g')::numeric, 0),
      coalesce((item ->> 'planned_fat_g')::numeric, 0),
      coalesce((item ->> 'servings')::numeric, 1)
    );
    item_index := item_index + 1;
  end loop;

  select coalesce(sum(planned_cost_cents), 0)
  into total_cost_cents
  from public.meal_slots
  where user_id = p_user_id
    and generated_plan_local_id = target_plan_local_id;

  update public.generated_plans
  set total_projected_cost_cents = total_cost_cents,
      is_over_budget = total_cost_cents > coalesce(
        (select weekly_budget_cents from public.user_profiles where user_id = p_user_id),
        0
      )
  where user_id = p_user_id and local_id = target_plan_local_id;

  insert into public.sync_records(
    user_id, entity_table, entity_id, operation, payload, updated_at
  ) values (
    p_user_id, 'MealSlots', p_entity_id, p_operation, p_payload, p_updated_at
  )
  on conflict (user_id, entity_table, entity_id) do update set
    operation = excluded.operation,
    payload = excluded.payload,
    updated_at = excluded.updated_at;

  return query select true, false;
end;
$$;

revoke all on function public.apply_meal_slot_components(uuid, bigint, text, jsonb, timestamptz)
  from public, authenticated;
grant execute on function public.apply_meal_slot_components(uuid, bigint, text, jsonb, timestamptz)
  to service_role;
