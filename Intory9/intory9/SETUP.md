# Intory9 – Setup

Dark premium shopping app in Flutter (Dart).
Colours: bg `#080D09`, primary lime `#B5E532`, cards `#111711`. Brand: **Intory** (white) + **9** (lime).

## 1. Run the app
1. Install Flutter (3.22+ / Dart 3.3+): https://docs.flutter.dev/get-started/install
2. In this folder, create the platform folders (Android, iOS, Web) once:
   ```
   flutter create . --project-name intory9 --org com.intory9 --platforms=android,ios,web
   ```
   (This keeps `lib/` and `pubspec.yaml` as they are.)
3. Get packages and run:
   ```
   flutter pub get
   flutter run
   ```
4. Fix any analyzer messages: `flutter analyze`

## 2. Demo logins
- Customer: any email + password (6+ chars) creates an account.
- Admin: `admin@intory9.com` + any 6+ char password opens the Admin panel.

## 3. What is inside
- Home, Shop (search, categories, sort, pagination), Product (size, colour, qty, Add to cart / Buy now)
- Cart + Checkout (address form, UPI / Card / Net Banking / COD, GST 18% + shipping)
- Orders list, order tracking, invoice PDF (view / print / share)
- Membership plans (Free / Plus / Pro), Login, Account
- Admin: Dashboard, Products (add/edit/delete), Orders (change status), Customers

## 4. Business rules (lib/data/store.dart)
- GST 18% on discounted subtotal
- Shipping Rs. 79, free above Rs. 999 or for Plus/Pro members
- Member discount: Plus 5%, Pro 12%

## 5. Real database (optional)
Data is in-memory right now. To go live:
1. Create a Supabase project, run `database/schema.sql` in the SQL editor.
2. Add `supabase_flutter` to pubspec and replace the methods in `AppStore` with Supabase calls.
3. Put your product photos in `assets/images/` and show them with `Image.asset` in `ProductThumb`.

## 6. Note
This code was written without a Flutter compiler available, so it has not been compiled yet.
Run `flutter analyze` first and fix any small issues.
