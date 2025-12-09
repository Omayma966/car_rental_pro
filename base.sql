-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.agents (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  profile_id uuid NOT NULL,
  full_name text NOT NULL,
  email text NOT NULL,
  phone text,
  active boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT agents_pkey PRIMARY KEY (id),
  CONSTRAINT agents_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.clients (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  first_name text NOT NULL,
  last_name text NOT NULL,
  email text NOT NULL,
  phone text NOT NULL,
  type text NOT NULL DEFAULT 'Particulier'::text,
  segment text NOT NULL DEFAULT 'Régulier'::text,
  address text,
  cin text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT clients_pkey PRIMARY KEY (id)
);
CREATE TABLE public.profiles (
  id uuid NOT NULL,
  full_name text,
  email text NOT NULL UNIQUE,
  role text NOT NULL CHECK (role = ANY (ARRAY['manager'::text, 'agent'::text])),
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT profiles_pkey PRIMARY KEY (id),
  CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
);
CREATE TABLE public.reservations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  client_id uuid NOT NULL,
  vehicle_id uuid NOT NULL,
  agent_id uuid,
  start_date date NOT NULL,
  end_date date NOT NULL,
  total_amount numeric NOT NULL DEFAULT 0,
  status text NOT NULL DEFAULT 'pending'::text,
  payment_status text NOT NULL DEFAULT 'unpaid'::text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT reservations_pkey PRIMARY KEY (id),
  CONSTRAINT reservations_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id),
  CONSTRAINT reservations_vehicle_id_fkey FOREIGN KEY (vehicle_id) REFERENCES public.vehicles(id),
  CONSTRAINT reservations_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES public.agents(id)
);
CREATE TABLE public.vehicles (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  brand text NOT NULL,
  model text NOT NULL,
  year integer NOT NULL,
  color text,
  seats integer NOT NULL DEFAULT 5,
  plate_number text NOT NULL UNIQUE,
  vin text,
  category text,
  transmission text,
  fuel_type text,
  price_per_day numeric NOT NULL,
  current_mileage integer NOT NULL DEFAULT 0,
  insurance_company text,
  insurance_number text,
  insurance_expiry_date date,
  last_tech_visit_date date,
  next_tech_visit_date date,
  next_oil_change_km integer,
  last_maintenance_date date,
  next_maintenance_date date,
  next_maintenance_km integer,
  notes text,
  photos ARRAY DEFAULT '{}'::text[],
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT vehicles_pkey PRIMARY KEY (id)
);


-- Autoriser TOUS les utilisateurs authentifiés à uploader dans le bucket "vehicles"
create policy "allow authenticated uploads on vehicles"
on storage.objects
for insert
to authenticated
with check (bucket_id = 'vehicle-photos');

-- Autoriser la lecture publique des fichiers du bucket "vehicles"
create policy "public read access on vehicles"
on storage.objects
for select
to public
using (bucket_id = 'vehicle-photos');

