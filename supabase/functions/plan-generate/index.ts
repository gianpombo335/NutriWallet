import { authenticatedUserId } from '../_shared/auth.ts';

const headers = { 'Content-Type': 'application/json' };
const models = [
  Deno.env.get('GEMINI_MODEL') ?? 'gemini-3.5-flash-lite',
  'gemini-2.5-flash-lite',
  'gemini-2.5-flash',
];

function response(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers });
}

Deno.serve(async (request) => {
  if (request.method !== 'POST') return response({ error: 'POST required' }, 405);
  if (!await authenticatedUserId(request)) {
    return response({ error: 'Authenticated user required' }, 401);
  }
  const key = Deno.env.get('GEMINI_API_KEY');
  if (!key) return response({ error: 'GEMINI_API_KEY is not configured' }, 503);
  const body = await request.json().catch(() => null) as Record<string, unknown> | null;
  if (!body?.dishes || !body.focus) return response({ error: 'Invalid plan request' }, 400);

  const focusInstructions: Record<string, string> = {
    balanced: 'Balance cost, calories, protein, carbohydrates, fat, and variety.',
    budget: 'Prioritize the lowest total cost, but keep the weekly nutrition targets as close as possible.',
    highProtein: 'Prioritize protein density and reaching the protein target while staying within budget and calories.',
    variety: 'Maximize distinct dishes and avoid consecutive repeats while still meeting the nutrition targets.',
    quick: 'Use a small, repeatable rotation of practical dishes while still meeting the nutrition targets and budget.',
  };
  const focusInstruction = focusInstructions[String(body.focus)] ??
      'Follow the supplied planning focus while meeting all supplied constraints.';
  const days = Array.isArray(body.days) ? body.days : [];
  const mealsPerDay = Number(body.meals_per_day ?? 0);
  const requestedSlots = days.length * mealsPerDay;
  const dishes = Array.isArray(body.dishes) ? body.dishes : [];
  if (requestedSlots <= 0 || dishes.length === 0) {
    return response({ error: 'No meal slots or dishes supplied' }, 400);
  }

  const prompt = [
    'Create a weekly meal plan recommendation from the supplied dishes.',
    `Planning focus: ${body.focus}. ${focusInstruction}`,
    `Weekly budget cents: ${body.budget_cents}. Never recommend a plan whose summed dish prices exceed this budget.`,
    `Display currency: ${body.currency_code ?? 'USD'}. Treat all supplied prices and budget values as that currency's minor units.`,
    `Active days: ${JSON.stringify(days)}. Meals per day: ${mealsPerDay}.`,
    `Weekly nutrition targets: ${JSON.stringify(body.targets)}. Prioritize calories and macros close to these targets.`,
    `Hard exclusions: ${JSON.stringify(body.exclusions ?? [])}. Never recommend a dish containing an excluded term.`,
    'Return JSON only in the form {"dish_ids":[number]}.',
    'Use only supplied dish IDs. Return exactly active_days_count * meals_per_day IDs, including repeats only when necessary. Avoid consecutive repeats when possible. Do not invent IDs or ignore the requested focus, budget, or nutrition targets.',
    `Dishes: ${JSON.stringify(dishes)}`,
  ].join('\n');
  let upstream: Response | null = null;
  for (const model of models) {
    upstream = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${encodeURIComponent(key)}`,
      {
        method: 'POST',
        headers,
        body: JSON.stringify({
          contents: [{ parts: [{ text: prompt }] }],
          generationConfig: { responseMimeType: 'application/json' },
        }),
      },
    );
    if (upstream.ok || ![400, 404].includes(upstream.status)) break;
  }
  if (!upstream || !upstream.ok) return response({ error: 'Gemini plan request failed' }, 502);
  const data = await upstream.json() as {
    candidates?: Array<{ content?: { parts?: Array<{ text?: string }> } }>;
  };
  const text = data.candidates?.[0]?.content?.parts?.[0]?.text;
  if (!text) return response({ error: 'Gemini returned no plan' }, 502);
  let parsed: { dish_ids?: unknown };
  try {
    parsed = JSON.parse(text.replace(/^```json\s*|\s*```$/g, '')) as {
      dish_ids?: unknown;
    };
  } catch (_) {
    return response({ error: 'Gemini returned malformed JSON' }, 422);
  }

  const dishIds = Array.isArray(parsed.dish_ids)
      ? parsed.dish_ids.filter((id): id is number => typeof id === 'number')
      : [];
  const byId = new Map<number, Record<string, unknown>>();
  for (const item of dishes) {
    if (typeof item !== 'object' || item === null) continue;
    const dish = item as Record<string, unknown>;
    if (typeof dish.id === 'number') byId.set(dish.id, dish);
  }
  const exclusions = Array.isArray(body.exclusions)
      ? body.exclusions.filter((item): item is string => typeof item === 'string')
          .map((item) => item.trim().toLowerCase())
          .filter(Boolean)
      : [];
  const selected = dishIds.map((id) => byId.get(id));
  const searchable = (dish: Record<string, unknown>) =>
      `${dish.name ?? ''} ${JSON.stringify(dish.ingredients ?? [])}`.toLowerCase();
  if (
    dishIds.length !== requestedSlots ||
    selected.some((dish) => !dish) ||
    selected.some((dish) => exclusions.some((term) => searchable(dish!).includes(term)))
  ) {
    return response({ error: 'Gemini returned an invalid slot or exclusion result' }, 422);
  }

  const totalCost = selected.reduce(
    (sum, dish) => sum + Number(dish?.price_cents ?? 0),
    0,
  );
  const budget = Number(body.budget_cents ?? 0);
  if (!Number.isFinite(totalCost) || totalCost > budget) {
    return response({ error: 'Gemini returned an over-budget plan' }, 422);
  }

  const targets = body.targets && typeof body.targets === 'object'
      ? body.targets as Record<string, unknown>
      : {};
  const protein = selected.reduce(
    (sum, dish) => sum + Number(dish?.protein_g ?? 0),
    0,
  );
  if (String(body.focus) === 'highProtein' &&
      protein < Number(targets.protein_g ?? 0) * 0.7) {
    return response({ error: 'Gemini returned a low-protein plan' }, 422);
  }
  if (String(body.focus) === 'variety' &&
      new Set(dishIds).size < Math.min(2, requestedSlots)) {
    return response({ error: 'Gemini returned an insufficiently varied plan' }, 422);
  }
  return response({ dish_ids: dishIds });
});
