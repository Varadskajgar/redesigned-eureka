-- Intory9 database (PostgreSQL / Supabase). Run in the SQL editor.
create extension if not exists "pgcrypto";

create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  email text unique,
  role text not null default 'customer' check (role in ('customer','admin')),
  plan text not null default 'Free' check (plan in ('Free','Plus','Pro')),
  created_at timestamptz default now()
);

create table products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text not null,
  description text default '',
  price numeric(10,2) not null check (price >= 0),
  rating numeric(2,1) default 4.5,
  sizes text[] default '{S,M,L,XL}',
  colors text[] default '{Black,White,Lime}',
  image_url text,
  active boolean default true,
  created_at timestamptz default now()
);

create table orders (
  id uuid primary key default gen_random_uuid(),
  order_no text unique not null,
  user_id uuid references profiles(id),
  customer_name text not null,
  phone text not null,
  address text not null,
  payment_method text not null check (payment_method in ('UPI','Card','Net Banking','Cash on Delivery')),
  subtotal numeric(10,2) not null,
  gst numeric(10,2) not null,
  shipping numeric(10,2) not null default 0,
  total numeric(10,2) not null,
  status text not null default 'placed'
    check (status in ('placed','packed','shipped','outForDelivery','delivered','cancelled')),
  created_at timestamptz default now()
);

create table order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid references orders(id) on delete cascade,
  product_id uuid references products(id),
  product_name text not null,
  size text, color text,
  qty int not null check (qty > 0),
  unit_price numeric(10,2) not null
);

create index on orders(user_id);
create index on order_items(order_id);

-- Row level security
alter table profiles enable row level security;
alter table products enable row level security;
alter table orders enable row level security;
alter table order_items enable row level security;

create or replace function is_admin() returns boolean language sql stable as
$$ select exists (select 1 from profiles where id = auth.uid() and role = 'admin') $$;

create policy "profile self" on profiles for select using (id = auth.uid() or is_admin());
create policy "profile update self" on profiles for update using (id = auth.uid());
create policy "products public read" on products for select using (active or is_admin());
create policy "products admin write" on products for all using (is_admin()) with check (is_admin());
create policy "orders own" on orders for select using (user_id = auth.uid() or is_admin());
create policy "orders insert own" on orders for insert with check (user_id = auth.uid());
create policy "orders admin update" on orders for update using (is_admin());
create policy "items own" on order_items for select using (
  exists (select 1 from orders o where o.id = order_id and (o.user_id = auth.uid() or is_admin())));
create policy "items insert own" on order_items for insert with check (
  exists (select 1 from orders o where o.id = order_id and o.user_id = auth.uid()));

-- Seed products
insert into products (name, category, description, price, rating) values
 ('Neon Core Hoodie','Hoodies','Heavyweight fleece hoodie with lime stitching.',2499,4.8),
 ('Midnight Tee','Tees','240 GSM combed cotton tee.',899,4.6),
 ('Shadow Cargo Pants','Pants','Relaxed cargo with six pockets.',1999,4.7),
 ('Volt Runner Shoes','Shoes','Lightweight runners with cushioned sole.',3999,4.9),
 ('Pulse Snapback Cap','Caps','Structured snapback with embroidered 9 logo.',599,4.4),
 ('Stealth Sling Bag','Bags','Water-resistant sling bag.',1299,4.5);

-- Make yourself admin after signing up:
-- update profiles set role = 'admin' where email = 'admin@intory9.com';
