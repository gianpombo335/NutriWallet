export async function authenticatedUserId(request: Request): Promise<string | null> {
  const authorization = request.headers.get('Authorization');
  const baseUrl = Deno.env.get('SUPABASE_URL');
  const publishableKeys = JSON.parse(
    Deno.env.get('SUPABASE_PUBLISHABLE_KEYS') ?? '{}',
  ) as Record<string, string>;
  const publishableKey = publishableKeys['default'];
  if (!authorization || !baseUrl) return null;

  const headers: Record<string, string> = { Authorization: authorization };
  if (publishableKey) headers.apikey = publishableKey;
  const response = await fetch(`${baseUrl}/auth/v1/user`, { headers });
  if (!response.ok) return null;
  const user = await response.json() as { id?: unknown };
  return typeof user.id === 'string' ? user.id : null;
}
