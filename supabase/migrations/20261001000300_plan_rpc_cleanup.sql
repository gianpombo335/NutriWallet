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
  perform p_profile_id;
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
