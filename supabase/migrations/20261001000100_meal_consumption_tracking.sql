alter table public.meal_slots
  add column if not exists meal_status text not null default 'planned',
  add column if not exists actual_cost_cents bigint,
  add column if not exists substitute_name text,
  add column if not exists consumed_at timestamptz;

alter table public.meal_slots
  drop constraint if exists meal_slots_meal_status_check;

alter table public.meal_slots
  add constraint meal_slots_meal_status_check
  check (meal_status in ('planned', 'eaten', 'substitute', 'skipped'));

create or replace function public.apply_meal_slot_consumption(
  p_user_id uuid,
  p_entity_id bigint,
  p_meal_status text,
  p_actual_cost_cents bigint,
  p_substitute_name text,
  p_consumed_at timestamptz
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.meal_slots
  set meal_status = p_meal_status,
      actual_cost_cents = p_actual_cost_cents,
      substitute_name = p_substitute_name,
      consumed_at = p_consumed_at
  where user_id = p_user_id and local_id = p_entity_id;
  return found;
end;
$$;

revoke all on function public.apply_meal_slot_consumption(uuid, bigint, text, bigint, text, timestamptz)
  from public, authenticated;
grant execute on function public.apply_meal_slot_consumption(uuid, bigint, text, bigint, text, timestamptz)
  to service_role;
