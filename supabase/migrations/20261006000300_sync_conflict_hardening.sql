drop function if exists public.apply_generated_plan(
  uuid, bigint, text, bigint, date, timestamptz, bigint, boolean,
  integer, boolean, text, text
);

create function public.apply_generated_plan(
  p_user_id uuid,
  p_entity_id bigint,
  p_operation text,
  p_profile_id bigint,
  p_week_start_date date,
  p_generated_at timestamptz,
  p_total_projected_cost_cents bigint,
  p_is_over_budget boolean,
  p_version integer,
  p_is_active boolean,
  p_planning_focus text,
  p_currency_code text,
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
  if p_entity_id <= 0
     or p_operation not in ('insert', 'update', 'delete') then
    return query select false, false;
    return;
  end if;
  if p_operation <> 'delete'
     and (p_total_projected_cost_cents < 0 or p_version < 1) then
    return query select false, false;
    return;
  end if;

  select updated_at into current_updated_at
  from public.sync_records
  where user_id = p_user_id
    and entity_table = 'GeneratedPlans'
    and entity_id = p_entity_id
  for update;

  if current_updated_at is not null and current_updated_at > p_updated_at then
    return query select false, true;
    return;
  end if;

  insert into public.sync_records(
    user_id, entity_table, entity_id, operation, payload, updated_at
  ) values (
    p_user_id,
    'GeneratedPlans',
    p_entity_id,
    p_operation,
    jsonb_build_object(
      'profile_id', p_profile_id,
      'week_start_date', p_week_start_date,
      'generated_at', p_generated_at,
      'total_projected_cost_cents', p_total_projected_cost_cents,
      'is_over_budget', p_is_over_budget,
      'version', p_version,
      'is_active', p_is_active,
      'planning_focus', p_planning_focus,
      'currency_code', p_currency_code
    ),
    p_updated_at
  )
  on conflict (user_id, entity_table, entity_id) do update set
    operation = excluded.operation,
    payload = excluded.payload,
    updated_at = excluded.updated_at;

  if p_operation = 'delete' then
    delete from public.generated_plans
    where user_id = p_user_id and local_id = p_entity_id;
    return query select true, false;
    return;
  end if;

  if p_is_active then
    update public.generated_plans
    set is_active = false
    where user_id = p_user_id and local_id <> p_entity_id;
  end if;

  insert into public.generated_plans(
    user_id, local_id, week_start_date, generated_at,
    total_projected_cost_cents, is_over_budget, version, is_active,
    planning_focus, currency_code
  ) values (
    p_user_id, p_entity_id, p_week_start_date, p_generated_at,
    p_total_projected_cost_cents, p_is_over_budget, p_version, p_is_active,
    coalesce(p_planning_focus, 'balanced'), coalesce(p_currency_code, 'USD')
  )
  on conflict (user_id, local_id) do update set
    week_start_date = excluded.week_start_date,
    generated_at = excluded.generated_at,
    total_projected_cost_cents = excluded.total_projected_cost_cents,
    is_over_budget = excluded.is_over_budget,
    version = excluded.version,
    is_active = excluded.is_active,
    planning_focus = excluded.planning_focus,
    currency_code = excluded.currency_code;

  return query select true, false;
end;
$$;

drop function if exists public.apply_budget_entry(
  uuid, bigint, text, bigint, bigint, bigint, text, timestamptz, timestamptz
);

create function public.apply_budget_entry(
  p_user_id uuid,
  p_entity_id bigint,
  p_operation text,
  p_generated_plan_local_id bigint,
  p_meal_slot_local_id bigint,
  p_amount_cents bigint,
  p_label text,
  p_occurred_at timestamptz,
  p_created_at timestamptz,
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
  if p_entity_id <= 0
     or p_operation not in ('insert', 'update', 'delete') then
    return query select false, false;
    return;
  end if;
  if p_operation <> 'delete' and p_amount_cents < 0 then
    return query select false, false;
    return;
  end if;

  select updated_at into current_updated_at
  from public.sync_records
  where user_id = p_user_id
    and entity_table = 'BudgetEntries'
    and entity_id = p_entity_id
  for update;

  if current_updated_at is not null and current_updated_at > p_updated_at then
    return query select false, true;
    return;
  end if;

  insert into public.sync_records(
    user_id, entity_table, entity_id, operation, payload, updated_at
  ) values (
    p_user_id,
    'BudgetEntries',
    p_entity_id,
    p_operation,
    jsonb_build_object(
      'generated_plan_id', p_generated_plan_local_id,
      'meal_slot_id', p_meal_slot_local_id,
      'amount_cents', p_amount_cents,
      'label', p_label,
      'occurred_at', p_occurred_at,
      'created_at', p_created_at
    ),
    p_updated_at
  )
  on conflict (user_id, entity_table, entity_id) do update set
    operation = excluded.operation,
    payload = excluded.payload,
    updated_at = excluded.updated_at;

  if p_operation = 'delete' then
    delete from public.budget_entries
    where user_id = p_user_id and local_id = p_entity_id;
    return query select true, false;
    return;
  end if;

  insert into public.budget_entries(
    user_id, local_id, generated_plan_local_id, meal_slot_local_id,
    amount_cents, label, occurred_at, created_at
  ) values (
    p_user_id, p_entity_id, p_generated_plan_local_id, p_meal_slot_local_id,
    p_amount_cents, coalesce(nullif(p_label, ''), 'Grocery trip'),
    p_occurred_at, p_created_at
  )
  on conflict (user_id, local_id) do update set
    generated_plan_local_id = excluded.generated_plan_local_id,
    meal_slot_local_id = excluded.meal_slot_local_id,
    amount_cents = excluded.amount_cents,
    label = excluded.label,
    occurred_at = excluded.occurred_at;

  return query select true, false;
end;
$$;

drop function if exists public.apply_meal_slot_consumption(
  uuid, bigint, text, bigint, text, timestamptz
);

create function public.apply_meal_slot_consumption(
  p_user_id uuid,
  p_entity_id bigint,
  p_meal_status text,
  p_actual_cost_cents bigint,
  p_substitute_name text,
  p_consumed_at timestamptz,
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
  if p_entity_id <= 0
     or p_meal_status not in ('planned', 'eaten', 'substitute', 'skipped')
     or p_actual_cost_cents < 0
     or (p_meal_status = 'substitute' and
         (p_actual_cost_cents is null or nullif(trim(p_substitute_name), '') is null))
     or (p_meal_status = 'skipped' and
         (p_actual_cost_cents is not null or p_substitute_name is not null)) then
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

  insert into public.sync_records(
    user_id, entity_table, entity_id, operation, payload, updated_at
  ) values (
    p_user_id,
    'MealSlots',
    p_entity_id,
    'update',
    jsonb_build_object(
      'meal_status', p_meal_status,
      'actual_cost_cents', p_actual_cost_cents,
      'substitute_name', p_substitute_name,
      'consumed_at', p_consumed_at
    ),
    p_updated_at
  )
  on conflict (user_id, entity_table, entity_id) do update set
    operation = excluded.operation,
    payload = excluded.payload,
    updated_at = excluded.updated_at;

  update public.meal_slots
  set meal_status = p_meal_status,
      actual_cost_cents = p_actual_cost_cents,
      substitute_name = p_substitute_name,
      consumed_at = p_consumed_at
  where user_id = p_user_id and local_id = p_entity_id;

  return query select found, false;
end;
$$;

revoke all on function public.apply_generated_plan(
  uuid, bigint, text, bigint, date, timestamptz, bigint, boolean,
  integer, boolean, text, text, timestamptz
) from public, authenticated;
grant execute on function public.apply_generated_plan(
  uuid, bigint, text, bigint, date, timestamptz, bigint, boolean,
  integer, boolean, text, text, timestamptz
) to service_role;

revoke all on function public.apply_budget_entry(
  uuid, bigint, text, bigint, bigint, bigint, text, timestamptz,
  timestamptz, timestamptz
) from public, authenticated;
grant execute on function public.apply_budget_entry(
  uuid, bigint, text, bigint, bigint, bigint, text, timestamptz,
  timestamptz, timestamptz
) to service_role;

revoke all on function public.apply_meal_slot_consumption(
  uuid, bigint, text, bigint, text, timestamptz, timestamptz
) from public, authenticated;
grant execute on function public.apply_meal_slot_consumption(
  uuid, bigint, text, bigint, text, timestamptz, timestamptz
) to service_role;
