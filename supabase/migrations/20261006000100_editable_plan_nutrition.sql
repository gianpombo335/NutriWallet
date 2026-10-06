alter table public.meal_slots
  add column if not exists planned_protein_g numeric not null default 0,
  add column if not exists planned_carbs_g numeric not null default 0,
  add column if not exists planned_fat_g numeric not null default 0,
  add column if not exists servings numeric not null default 1;

create or replace function public.apply_meal_slot_edit(
  p_user_id uuid,
  p_entity_id bigint,
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
  budget_cents bigint;
  total_cost_cents bigint;
  new_dish_local_id bigint;
  serving_count numeric;
  base_price_cents bigint;
  base_calories numeric;
  base_protein_g numeric;
  base_carbs_g numeric;
  base_fat_g numeric;
begin
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

  new_dish_local_id := (p_payload ->> 'dish_id')::bigint;
  serving_count := coalesce((p_payload ->> 'servings')::numeric, 1);
  if serving_count < 0.5 or serving_count > 20 then
    return query select false, false;
    return;
  end if;

  select
    d.price_cents,
    coalesce(sum(i.calories), 0),
    coalesce(sum(i.protein_g), 0),
    coalesce(sum(i.carbs_g), 0),
    coalesce(sum(i.fat_g), 0)
  into
    base_price_cents,
    base_calories,
    base_protein_g,
    base_carbs_g,
    base_fat_g
  from public.dishes d
  left join public.ingredients i
    on i.user_id = d.user_id and i.dish_local_id = d.local_id
  where d.user_id = p_user_id
    and d.local_id = new_dish_local_id
    and d.is_deleted = false
  group by d.price_cents;

  if not found then
    return query select false, false;
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

  update public.meal_slots
  set dish_local_id = new_dish_local_id,
      planned_cost_cents = round(base_price_cents * serving_count),
      planned_calories = base_calories * serving_count,
      planned_protein_g = base_protein_g * serving_count,
      planned_carbs_g = base_carbs_g * serving_count,
      planned_fat_g = base_fat_g * serving_count,
      servings = serving_count
  where user_id = p_user_id and local_id = p_entity_id;

  select coalesce(sum(planned_cost_cents), 0)
    into total_cost_cents
  from public.meal_slots
  where user_id = p_user_id and generated_plan_local_id = target_plan_local_id;

  select weekly_budget_cents into budget_cents
  from public.user_profiles
  where user_id = p_user_id;

  update public.generated_plans
  set total_projected_cost_cents = total_cost_cents,
      is_over_budget = total_cost_cents > coalesce(budget_cents, 0)
  where user_id = p_user_id and local_id = target_plan_local_id;

  insert into public.sync_records(
    user_id, entity_table, entity_id, operation, payload, updated_at
  ) values (
    p_user_id, 'MealSlots', p_entity_id, 'update', p_payload, p_updated_at
  )
  on conflict (user_id, entity_table, entity_id) do update set
    operation = excluded.operation,
    payload = excluded.payload,
    updated_at = excluded.updated_at;

  return query select true, false;
end;
$$;

revoke all on function public.apply_meal_slot_edit(uuid, bigint, jsonb, timestamptz)
  from public, authenticated;
grant execute on function public.apply_meal_slot_edit(uuid, bigint, jsonb, timestamptz)
  to service_role;
