import { authenticatedUserId } from '../_shared/auth.ts';

const jsonHeaders = { 'Content-Type': 'application/json' };
const models = [
  Deno.env.get('GEMINI_MODEL') ?? 'gemini-3.5-flash-lite',
  'gemini-2.5-flash-lite',
  'gemini-2.5-flash',
];

function response(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: jsonHeaders });
}

Deno.serve(async (request) => {
  if (request.method !== 'POST') return response({ error: 'POST required' }, 405);
  if (!await authenticatedUserId(request)) {
    return response({ error: 'Authenticated user required' }, 401);
  }
  const key = Deno.env.get('GEMINI_API_KEY');
  if (!key) return response({ error: 'GEMINI_API_KEY is not configured' }, 503);

  const body = await request.json().catch(() => null) as {
    image_base64?: string;
    mime_type?: string;
  } | null;
  if (!body?.image_base64) {
    return response({ error: 'image_base64 is required' }, 400);
  }

  let upstream: Response | null = null;
  for (const model of models) {
    upstream = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${encodeURIComponent(key)}`,
      {
        method: 'POST',
        headers: jsonHeaders,
        body: JSON.stringify({
          contents: [{
            parts: [
              {
                inline_data: {
                  mime_type: body.mime_type ?? 'image/jpeg',
                  data: body.image_base64,
                },
              },
              {
                text: 'Identify the visible dish. Return JSON only with this shape: {"meal_name":"string","ingredients":["string"],"cuisine":"string","allergens":["string"]}. Use a concise appetizing meal name, common ingredient names, and do not include explanations.',
              },
            ],
          }],
          generationConfig: { responseMimeType: 'application/json' },
        }),
      },
    );
    if (upstream.ok || ![400, 404].includes(upstream.status)) break;
  }
  if (!upstream || !upstream.ok) {
    return response({ error: 'Gemini request failed', status: upstream.status }, 502);
  }

  const data = await upstream.json() as {
    candidates?: Array<{ content?: { parts?: Array<{ text?: string }> } }>;
  };
  const text = data.candidates?.[0]?.content?.parts?.[0]?.text;
  if (!text) return response({ error: 'Gemini returned no recognition result' }, 502);
  let parsed: {
    meal_name?: unknown;
    ingredients?: unknown;
    cuisine?: unknown;
    allergens?: unknown;
  };
  try {
    parsed = JSON.parse(text.replace(/^```json\s*|\s*```$/g, '')) as {
      meal_name?: unknown;
      ingredients?: unknown;
      cuisine?: unknown;
      allergens?: unknown;
    };
  } catch (_) {
    return response({ error: 'Gemini returned malformed recognition JSON' }, 422);
  }
  const ingredients = Array.isArray(parsed.ingredients)
      ? parsed.ingredients.filter((item): item is string => typeof item === 'string')
      : [];
  if (ingredients.length === 0) {
    return response({ error: 'Gemini returned no ingredients' }, 422);
  }
  return response({
    meal_name: typeof parsed.meal_name === 'string' ? parsed.meal_name : null,
    ingredients,
    cuisine: typeof parsed.cuisine === 'string' ? parsed.cuisine : null,
    allergens: Array.isArray(parsed.allergens)
        ? parsed.allergens.filter((item): item is string => typeof item === 'string')
        : [],
  });
});
