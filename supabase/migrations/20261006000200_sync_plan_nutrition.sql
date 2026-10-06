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
  account_email text;
begin
  if p_entity_table not in (
    'UserProfiles', 'Dishes', 'Ingredients', 'AllergenTags',
    'GeneratedPlans', 'MealSlots', 'BudgetEntries'
  ) or p_operation not in ('insert', 'update', 'delete')
     or p_entity_id <= 0 then
    return query select false, false;
    return;
  end if;

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

  if p_entity_table = 'UserProfiles' then
    if p_operation = 'delete' then
      delete from public.user_profiles where user_id = p_user_id;
    else
      select email into account_email from auth.users where id = p_user_id;
      insert into public.user_profiles(
        user_id, email, display_name, weekly_budget_cents, active_days,
        meals_per_day, weight_kg, height_cm, age, sex, activity_level,
        goal_preset, created_at, updated_at
      ) values (
        p_user_id,
        coalesce(p_payload ->> 'email', account_email, ''),
        p_payload ->> 'display_name',
        coalesce((p_payload ->> 'weekly_budget_cents')::bigint, 0),
        coalesce(p_payload ->> 'active_days', '1,2,3,4,5,6,7'),
        coalesce((p_payload ->> 'meals_per_day')::integer, 3),
        (p_payload ->> 'weight_kg')::numeric,
        (p_payload ->> 'height_cm')::numeric,
        (p_payload ->> 'age')::integer,
        p_payload ->> 'sex',
        coalesce(p_payload ->> 'activity_level', 'moderate'),
        coalesce(p_payload ->> 'goal_preset', 'balanced'),
        coalesce((p_payload ->> 'created_at')::timestamptz, p_updated_at),
        p_updated_at
      )
      on conflict (user_id) do update set
        email = excluded.email,
        display_name = excluded.display_name,
        weekly_budget_cents = excluded.weekly_budget_cents,
        active_days = excluded.active_days,
        meals_per_day = excluded.meals_per_day,
        weight_kg = excluded.weight_kg,
        height_cm = excluded.height_cm,
        age = excluded.age,
        sex = excluded.sex,
        activity_level = excluded.activity_level,
        goal_preset = excluded.goal_preset,
        updated_at = excluded.updated_at;
    end if;
  elsif p_entity_table = 'Dishes' then
    if p_operation = 'delete' then
      update public.dishes
      set is_deleted = true, updated_at = p_updated_at
      where user_id = p_user_id and local_id = p_entity_id;
    else
       if coalesce((p_payload ->> 'price_cents')::bigint, 0) < 0 then
         return query select false, false;
         return;
       end if;
       insert into public.dishes(
        user_id, local_id, name, price_cents, cuisine_tag, photo_path,
        source, created_at, updated_at, is_deleted
      ) values (
        p_user_id,
        p_entity_id,
        coalesce(p_payload ->> 'name', 'Unnamed dish'),
        coalesce((p_payload ->> 'price_cents')::bigint, 0),
        p_payload ->> 'cuisine_tag',
        p_payload ->> 'photo_path',
        coalesce(p_payload ->> 'source', 'manual'),
        coalesce((p_payload ->> 'created_at')::timestamptz, p_updated_at),
        p_updated_at,
        coalesce((p_payload ->> 'is_deleted')::boolean, false)
      )
      on conflict (user_id, local_id) do update set
        name = excluded.name,
        price_cents = excluded.price_cents,
        cuisine_tag = excluded.cuisine_tag,
        photo_path = excluded.photo_path,
        source = excluded.source,
        updated_at = excluded.updated_at,
        is_deleted = excluded.is_deleted;
    end if;
  elsif p_entity_table = 'Ingredients' then
    if p_operation = 'delete' then
      delete from public.ingredients
      where user_id = p_user_id and local_id = p_entity_id;
    else
       if coalesce((p_payload ->> 'calories')::numeric, 0) < 0
          or coalesce((p_payload ->> 'protein_g')::numeric, 0) < 0
          or coalesce((p_payload ->> 'carbs_g')::numeric, 0) < 0
          or coalesce((p_payload ->> 'fat_g')::numeric, 0) < 0 then
         return query select false, false;
         return;
       end if;
       insert into public.ingredients(
        user_id, dish_local_id, local_id, name, quantity, unit, calories,
        protein_g, carbs_g, fat_g, micronutrients_json, usda_fdc_id,
        is_cached_from_api
      ) values (
        p_user_id,
        (p_payload ->> 'dish_id')::bigint,
        p_entity_id,
        coalesce(p_payload ->> 'name', 'Unnamed ingredient'),
        coalesce((p_payload ->> 'quantity')::numeric, 1),
        coalesce(p_payload ->> 'unit', 'serving'),
        coalesce((p_payload ->> 'calories')::numeric, 0),
        coalesce((p_payload ->> 'protein_g')::numeric, 0),
        coalesce((p_payload ->> 'carbs_g')::numeric, 0),
        coalesce((p_payload ->> 'fat_g')::numeric, 0),
        (p_payload -> 'micronutrients_json'),
        (p_payload ->> 'usda_fdc_id')::bigint,
        coalesce((p_payload ->> 'is_cached_from_api')::boolean, false)
      )
      on conflict (user_id, local_id) do update set
        dish_local_id = excluded.dish_local_id,
        name = excluded.name,
        quantity = excluded.quantity,
        unit = excluded.unit,
        calories = excluded.calories,
        protein_g = excluded.protein_g,
        carbs_g = excluded.carbs_g,
        fat_g = excluded.fat_g,
        micronutrients_json = excluded.micronutrients_json,
        usda_fdc_id = excluded.usda_fdc_id,
        is_cached_from_api = excluded.is_cached_from_api;
    end if;
  elsif p_entity_table = 'AllergenTags' then
    if p_operation = 'delete' then
      delete from public.allergen_tags
      where user_id = p_user_id and local_id = p_entity_id;
    else
      insert into public.allergen_tags(user_id, local_id, label)
      values (p_user_id, p_entity_id, coalesce(p_payload ->> 'label', ''))
      on conflict (user_id, local_id) do update set label = excluded.label;
    end if;
  elsif p_entity_table = 'GeneratedPlans' then
    if p_operation = 'delete' then
      delete from public.generated_plans
      where user_id = p_user_id and local_id = p_entity_id;
    else
       if coalesce((p_payload ->> 'total_projected_cost_cents')::bigint, 0) < 0
          or coalesce((p_payload ->> 'version')::integer, 1) < 1 then
         return query select false, false;
         return;
       end if;
       if coalesce((p_payload ->> 'is_active')::boolean, false) then
        update public.generated_plans set is_active = false
        where user_id = p_user_id and local_id <> p_entity_id;
      end if;
      insert into public.generated_plans(
        user_id, local_id, week_start_date, generated_at,
        total_projected_cost_cents, is_over_budget, version, is_active
      ) values (
        p_user_id,
        p_entity_id,
        coalesce((p_payload ->> 'week_start_date')::date, p_updated_at::date),
        coalesce((p_payload ->> 'generated_at')::timestamptz, p_updated_at),
        coalesce((p_payload ->> 'total_projected_cost_cents')::bigint, 0),
        coalesce((p_payload ->> 'is_over_budget')::boolean, false),
        coalesce((p_payload ->> 'version')::integer, 1),
        coalesce((p_payload ->> 'is_active')::boolean, false)
      )
      on conflict (user_id, local_id) do update set
        week_start_date = excluded.week_start_date,
        generated_at = excluded.generated_at,
        total_projected_cost_cents = excluded.total_projected_cost_cents,
        is_over_budget = excluded.is_over_budget,
        version = excluded.version,
        is_active = excluded.is_active;
    end if;
  elsif p_entity_table = 'MealSlots' then
    if p_operation = 'delete' then
      delete from public.meal_slots
      where user_id = p_user_id and local_id = p_entity_id;
    else
       if coalesce((p_payload ->> 'planned_cost_cents')::bigint, 0) < 0
          or coalesce((p_payload ->> 'planned_calories')::numeric, 0) < 0
          or coalesce((p_payload ->> 'planned_protein_g')::numeric, 0) < 0
          or coalesce((p_payload ->> 'planned_carbs_g')::numeric, 0) < 0
          or coalesce((p_payload ->> 'planned_fat_g')::numeric, 0) < 0
          or coalesce((p_payload ->> 'servings')::numeric, 1) < 0.5
          or coalesce((p_payload ->> 'servings')::numeric, 1) > 20 then
         return query select false, false;
         return;
       end if;
       insert into public.meal_slots(
        user_id, local_id, generated_plan_local_id, dish_local_id,
        day_index, slot_index, planned_cost_cents, planned_calories,
        planned_protein_g, planned_carbs_g, planned_fat_g, servings
      ) values (
        p_user_id,
        p_entity_id,
        (p_payload ->> 'generated_plan_id')::bigint,
        (p_payload ->> 'dish_id')::bigint,
        coalesce((p_payload ->> 'day_index')::integer, 0),
        coalesce((p_payload ->> 'slot_index')::integer, 0),
        coalesce((p_payload ->> 'planned_cost_cents')::bigint, 0),
        coalesce((p_payload ->> 'planned_calories')::numeric, 0),
        coalesce((p_payload ->> 'planned_protein_g')::numeric, 0),
        coalesce((p_payload ->> 'planned_carbs_g')::numeric, 0),
        coalesce((p_payload ->> 'planned_fat_g')::numeric, 0),
        coalesce((p_payload ->> 'servings')::numeric, 1)
      )
      on conflict (user_id, local_id) do update set
        generated_plan_local_id = excluded.generated_plan_local_id,
        dish_local_id = excluded.dish_local_id,
        day_index = excluded.day_index,
        slot_index = excluded.slot_index,
        planned_cost_cents = excluded.planned_cost_cents,
        planned_calories = excluded.planned_calories,
        planned_protein_g = excluded.planned_protein_g,
        planned_carbs_g = excluded.planned_carbs_g,
        planned_fat_g = excluded.planned_fat_g,
        servings = excluded.servings;
    end if;
  elsif p_entity_table = 'BudgetEntries' then
    if p_operation = 'delete' then
      delete from public.budget_entries
      where user_id = p_user_id and local_id = p_entity_id;
    else
       if coalesce((p_payload ->> 'amount_cents')::bigint, 0) < 0 then
         return query select false, false;
         return;
       end if;
       insert into public.budget_entries(
        user_id, local_id, generated_plan_local_id, amount_cents, label,
        occurred_at, created_at
      ) values (
        p_user_id,
        p_entity_id,
        (p_payload ->> 'generated_plan_id')::bigint,
        coalesce((p_payload ->> 'amount_cents')::bigint, 0),
        coalesce(p_payload ->> 'label', 'Grocery trip'),
        coalesce((p_payload ->> 'occurred_at')::timestamptz, p_updated_at),
        p_updated_at
      )
      on conflict (user_id, local_id) do update set
        generated_plan_local_id = excluded.generated_plan_local_id,
        amount_cents = excluded.amount_cents,
        label = excluded.label,
        occurred_at = excluded.occurred_at;
    end if;
  end if;

  return query select true, false;
end;
$$;

alter table public.user_profiles
  drop constraint if exists user_profiles_budget_nonnegative;
alter table public.user_profiles
  add constraint user_profiles_budget_nonnegative
  check (weekly_budget_cents >= 0) not valid;

alter table public.dishes
  drop constraint if exists dishes_price_nonnegative;
alter table public.dishes
  add constraint dishes_price_nonnegative
  check (price_cents >= 0) not valid;

alter table public.ingredients
  drop constraint if exists ingredients_nutrition_nonnegative;
alter table public.ingredients
  add constraint ingredients_nutrition_nonnegative
  check (calories >= 0 and protein_g >= 0 and carbs_g >= 0 and fat_g >= 0) not valid;

alter table public.budget_entries
  drop constraint if exists budget_entries_amount_nonnegative;
alter table public.budget_entries
  add constraint budget_entries_amount_nonnegative
  check (amount_cents >= 0) not valid;
