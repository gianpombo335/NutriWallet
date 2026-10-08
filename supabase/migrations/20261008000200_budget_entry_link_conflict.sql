create or replace function public.apply_budget_entry(
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
  existing_linked_local_id bigint;
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

  if p_operation = 'delete' then
    delete from public.budget_entries
    where user_id = p_user_id and local_id = p_entity_id;
    delete from public.sync_records
    where user_id = p_user_id
      and entity_table = 'BudgetEntries'
      and entity_id = p_entity_id;
    return query select true, false;
    return;
  end if;

  if p_meal_slot_local_id is not null then
    select local_id into existing_linked_local_id
    from public.budget_entries
    where user_id = p_user_id
      and meal_slot_local_id = p_meal_slot_local_id
    for update;

    if existing_linked_local_id is not null
       and existing_linked_local_id <> p_entity_id then
      delete from public.budget_entries
      where user_id = p_user_id and local_id = existing_linked_local_id;
      delete from public.sync_records
      where user_id = p_user_id
        and entity_table = 'BudgetEntries'
        and entity_id = existing_linked_local_id;
    end if;
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

  insert into public.budget_entries(
    user_id, local_id, generated_plan_local_id, meal_slot_local_id,
    amount_cents, label, occurred_at, created_at
  ) values (
    p_user_id,
    p_entity_id,
    p_generated_plan_local_id,
    p_meal_slot_local_id,
    p_amount_cents,
    coalesce(nullif(p_label, ''), 'Grocery trip'),
    p_occurred_at,
    p_created_at
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

revoke all on function public.apply_budget_entry(
  uuid, bigint, text, bigint, bigint, bigint, text, timestamptz,
  timestamptz, timestamptz
) from public, authenticated;
grant execute on function public.apply_budget_entry(
  uuid, bigint, text, bigint, bigint, bigint, text, timestamptz,
  timestamptz, timestamptz
) to service_role;
