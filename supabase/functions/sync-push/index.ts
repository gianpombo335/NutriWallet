import { authenticatedUserId } from '../_shared/auth.ts';

const jsonHeaders = { 'Content-Type': 'application/json' };

function response(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: jsonHeaders });
}

async function restRequest(path: string, init: RequestInit = {}) {
  const baseUrl = Deno.env.get('SUPABASE_URL');
  const secretKeys = JSON.parse(
    Deno.env.get('SUPABASE_SECRET_KEYS') ?? '{}',
  ) as Record<string, string>;
  const serviceKey = secretKeys['default'];
  if (!baseUrl || !serviceKey) throw new Error('Supabase service configuration is missing');
  return fetch(`${baseUrl}/rest/v1/${path}`, {
    ...init,
    headers: {
      ...jsonHeaders,
      apikey: serviceKey,
      ...(init.headers ?? {}),
    },
  });
}

Deno.serve(async (request) => {
  if (request.method !== 'POST') return response({ error: 'POST required' }, 405);
  const userId = await authenticatedUserId(request);
  if (!userId) return response({ error: 'Authenticated user required' }, 401);

  const body = await request.json().catch(() => null) as {
    entity_table?: string;
    entity_id?: number;
    operation?: string;
    payload?: Record<string, unknown>;
    updated_at?: string;
  } | null;
  if (!body?.entity_table || !body.entity_id || !body.operation || !body.updated_at) {
    return response({ error: 'Invalid sync payload' }, 400);
  }

  if (
    body.entity_table === 'GeneratedPlans' &&
    body.payload?.planning_focus
  ) {
    const payload = body.payload;
    const planResponse = await restRequest('rpc/apply_generated_plan', {
      method: 'POST',
      headers: { Prefer: 'return=representation' },
      body: JSON.stringify({
        p_user_id: userId,
        p_entity_id: body.entity_id,
        p_operation: body.operation,
        p_profile_id: payload.profile_id ?? null,
        p_week_start_date: payload.week_start_date,
        p_generated_at: payload.generated_at,
        p_total_projected_cost_cents: payload.total_projected_cost_cents ?? 0,
        p_is_over_budget: payload.is_over_budget === true,
        p_version: payload.version ?? 1,
        p_is_active: payload.is_active === true,
        p_planning_focus: payload.planning_focus,
        p_currency_code: payload.currency_code ?? 'USD',
      }),
    });
    if (!planResponse.ok) return response({ error: 'Plan write failed' }, 502);
    return response({ accepted: true, conflict: false });
  }

  if (
    body.entity_table === 'MealSlots' &&
    body.operation === 'update' &&
    body.payload?.meal_status
  ) {
    const payload = body.payload;
    const consumptionResponse = await restRequest('rpc/apply_meal_slot_consumption', {
      method: 'POST',
      headers: { Prefer: 'return=representation' },
      body: JSON.stringify({
        p_user_id: userId,
        p_entity_id: body.entity_id,
        p_meal_status: payload.meal_status,
        p_actual_cost_cents: payload.actual_cost_cents ?? null,
        p_substitute_name: payload.substitute_name ?? null,
        p_consumed_at: payload.consumed_at ?? null,
      }),
    });
    if (!consumptionResponse.ok) return response({ error: 'Meal update failed' }, 502);
    return response({ accepted: true, conflict: false });
  }

  if (body.entity_table === 'BudgetEntries' && body.payload?.meal_slot_id) {
    const payload = body.payload;
    const budgetResponse = await restRequest('rpc/apply_budget_entry', {
      method: 'POST',
      headers: { Prefer: 'return=representation' },
      body: JSON.stringify({
        p_user_id: userId,
        p_entity_id: body.entity_id,
        p_operation: body.operation,
        p_generated_plan_local_id: payload.generated_plan_id ?? null,
        p_meal_slot_local_id: payload.meal_slot_id ?? null,
        p_amount_cents: payload.amount_cents ?? 0,
        p_label: payload.label ?? 'Grocery trip',
        p_occurred_at: payload.occurred_at ?? body.updated_at,
        p_created_at: body.updated_at,
      }),
    });
    if (!budgetResponse.ok) return response({ error: 'Budget write failed' }, 502);
    return response({ accepted: true, conflict: false });
  }

  const rpcResponse = await restRequest('rpc/apply_sync_record', {
    method: 'POST',
    headers: { Prefer: 'return=representation' },
    body: JSON.stringify({
      p_user_id: userId,
      p_entity_table: body.entity_table,
      p_entity_id: body.entity_id,
      p_operation: body.operation,
      p_payload: body.payload ?? {},
      p_updated_at: body.updated_at,
    }),
  });
  if (!rpcResponse.ok) return response({ error: 'Sync write failed' }, 502);
  const result = (await rpcResponse.json()) as Array<{
    accepted?: boolean;
    conflict?: boolean;
  }>;
  return response(result[0] ?? { accepted: false, conflict: false });
});
