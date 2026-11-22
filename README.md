# Kalakriti Interior — Billing

Billing, payments, quotations and inventory for Kalakriti Interior.
A single page (`index.html`) hosted on Vercel, with data stored in Supabase and synced live across all team devices.

- **Login:** one shared team password, checked by Supabase (account `team@kalakriti.app`). The password is not stored in this repo.
- **Database:** Supabase project "Kalakriti". `supabase-setup.sql` is the schema, security rules and bill-number counter.
- **Deploys:** every push to `main` goes live automatically on Vercel.
- **Change the team password:** run the line at the bottom of `supabase-setup.sql` in Supabase → SQL Editor.
