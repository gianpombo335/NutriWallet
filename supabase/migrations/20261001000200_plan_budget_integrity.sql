alter table public.generated_plans
  add column if not exists planning_focus text not null default 'balanced',
  add column if not exists currency_code text not null default 'USD';

alter table public.budget_entries
  add column if not exists meal_slot_local_id bigint;

create unique index if not exists budget_entries_meal_slot_unique
  on public.budget_entries (user_id, meal_slot_local_id)
  where meal_slot_local_id is not null;

create or replace function public.apply_generated_plan(
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
  p_currency_code text
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_operation = 'delete' then
    delete from public.generated_plans
    where user_id = p_user_id and local_id = p_entity_id;
    return found;
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
  return true;
end;
$$;

create or replace function public.apply_budget_entry(
  p_user_id uuid,
  p_entity_id bigint,
  p_operation text,
  p_generated_plan_local_id bigint,
  p_meal_slot_local_id bigint,
  p_amount_cents bigint,
  p_label text,
  p_occurred_at timestamptz,
  p_created_at timestamptz
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_operation = 'delete' then
    delete from public.budget_entries
    where user_id = p_user_id and local_id = p_entity_id;
    return found;
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
  return true;
end;
$$;

revoke all on function public.apply_generated_plan(uuid, bigint, text, bigint, date, timestamptz, bigint, boolean, integer, boolean, text, text)
  from public, authenticated;
grant execute on function public.apply_generated_plan(uuid, bigint, text, bigint, date, timestamptz, bigint, boolean, integer, boolean, text, text)
  to service_role;

revoke all on function public.apply_budget_entry(uuid, bigint, text, bigint, bigint, bigint, text, timestamptz, timestamptz)
  from public, authenticated;
grant execute on function public.apply_budget_entry(uuid, bigint, text, bigint, bigint, bigint, text, timestamptz, timestamptz)
  to service_role;
