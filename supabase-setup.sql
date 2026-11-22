-- Kalakriti Interior billing — database setup
-- Already applied to the Kalakriti Supabase project. Kept here as a record, and to rebuild the database if ever needed.

-- 1. Tables: every vendor, bill, product, material and the company details is one row
create table if not exists records (
  id   text primary key,
  kind text not null,
  data jsonb not null
);

-- Bill / quotation numbers, handed out one at a time so two people never get the same number
create table if not exists counters (
  name  text primary key,
  value int  not null default 0
);

-- 2. Security: only the signed-in team account can read or change anything
alter table records  enable row level security;
alter table counters enable row level security;

create policy "team only" on records  for all to authenticated using (true) with check (true);
create policy "team only" on counters for all to authenticated using (true) with check (true);
grant select, insert, update, delete on records, counters to authenticated;
revoke all on records, counters from anon;

-- 3. Next bill / quotation number
create or replace function next_no(t text) returns int
language sql security invoker as $$
  insert into counters(name, value) values (t, 1)
  on conflict (name) do update set value = counters.value + 1
  returning value;
$$;
revoke execute on function next_no(text) from anon, public;
grant execute on function next_no(text) to authenticated;

-- 4. Live updates to every device
alter publication supabase_realtime add table records;


-- ─────────────────────────────────────────────────────────────
-- LATER: to change the team password, run just this line
-- (replace NewPassword123 with the new password):
--
-- update auth.users set encrypted_password = crypt('NewPassword123', gen_salt('bf')) where email = 'team@kalakriti.app';
