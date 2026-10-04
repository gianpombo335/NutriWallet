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

  if p_entity_table = 'Dishes' then
    if p_operation = 'delete' then
      update public.dishes
      set is_deleted = true, updated_at = p_updated_at
      where user_id = p_user_id and local_id = p_entity_id;
    else
      insert into public.dishes(
        user_id, local_id, name, price_cents, source,
        created_at, updated_at, is_deleted
      ) values (
        p_user_id,
        p_entity_id,
        coalesce(p_payload ->> 'name', 'Unnamed dish'),
        coalesce((p_payload ->> 'price_cents')::bigint, 0),
        coalesce(p_payload ->> 'source', 'manual'),
        p_updated_at,
        p_updated_at,
        false
      )
      on conflict (user_id, local_id) do update set
        name = excluded.name,
        price_cents = excluded.price_cents,
        source = excluded.source,
        updated_at = excluded.updated_at,
        is_deleted = false;
    end if;
  elsif p_entity_table = 'BudgetEntries' then
    if p_operation = 'delete' then
      delete from public.budget_entries
      where user_id = p_user_id and local_id = p_entity_id;
    else
      insert into public.budget_entries(
        user_id, local_id, amount_cents, label, occurred_at, created_at
      ) values (
        p_user_id,
        p_entity_id,
        coalesce((p_payload ->> 'amount_cents')::bigint, 0),
        coalesce(p_payload ->> 'label', 'Grocery trip'),
        coalesce((p_payload ->> 'occurred_at')::timestamptz, p_updated_at),
        p_updated_at
      )
      on conflict (user_id, local_id) do update set
        amount_cents = excluded.amount_cents,
        label = excluded.label,
        occurred_at = excluded.occurred_at;
    end if;
  end if;

  return query select true, false;
end;
$$;

revoke all on function public.apply_sync_record(uuid, text, bigint, text, jsonb, timestamptz)
  from public, authenticated;
grant execute on function public.apply_sync_record(uuid, text, bigint, text, jsonb, timestamptz)
  to service_role;
