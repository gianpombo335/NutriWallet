import { authenticatedUserId } from '../_shared/auth.ts';

const jsonHeaders = { 'Content-Type': 'application/json' };

function response(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: jsonHeaders });
}

Deno.serve(async (request) => {
  if (request.method !== 'POST') return response({ error: 'POST required' }, 405);
  if (!await authenticatedUserId(request)) {
    return response({ error: 'Authenticated user required' }, 401);
  }
  const key = Deno.env.get('USDA_API_KEY');
  if (!key) return response({ error: 'USDA_API_KEY is not configured' }, 503);

  const body = await request.json().catch(() => null) as { ingredient?: string } | null;
  const ingredient = body?.ingredient?.trim().toLowerCase();
  if (!ingredient) return response({ error: 'ingredient is required' }, 400);

  const upstream = await fetch(
    `https://api.nal.usda.gov/fdc/v1/foods/search?api_key=${encodeURIComponent(key)}&query=${encodeURIComponent(ingredient)}&dataType=Foundation,SR%20Legacy&pageSize=25`,
  );
  if (!upstream.ok) {
    return response({ error: 'USDA lookup failed', status: upstream.status }, 502);
  }

  const data = await upstream.json() as { foods?: Array<Record<string, unknown>> };
  const nutrientsFor = (item: Record<string, unknown>) =>
      (item.foodNutrients as Array<Record<string, unknown>> | undefined) ?? [];
  const food = data.foods?.find((item) => {
    const numbers = new Set(
      nutrientsFor(item).map(
        (nutrient) =>
            String(nutrient.nutrientNumber ?? nutrient.nutrientId ?? nutrient.number),
      ),
    );
    return (numbers.has('1008') || numbers.has('208')) &&
        (numbers.has('1003') || numbers.has('203'));
  }) ?? data.foods?.[0];
  if (!food) return new Response(null, { status: 204, headers: jsonHeaders });
  const nutrients = nutrientsFor(food);
  const valueFor = (...numbers: string[]) => {
    const nutrient = nutrients.find(
      (item) =>
        numbers.includes(
          String(item.nutrientNumber ?? item.nutrientId ?? item.number),
        ),
    );
    return typeof nutrient?.value === 'number' ? nutrient.value : 0;
  };

  return response({
    name: ingredient,
    calories: valueFor('1008', '208'),
    protein_g: valueFor('1003', '203'),
    carbs_g: valueFor('1005', '205'),
    fat_g: valueFor('1004', '204'),
    fdc_id: food.fdcId ?? null,
  });
});
