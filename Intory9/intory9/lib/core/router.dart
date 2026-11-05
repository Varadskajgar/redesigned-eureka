import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/store.dart';
import '../screens/account.dart';
import '../screens/admin.dart';
import '../screens/cart.dart';
import '../screens/checkout.dart';
import '../screens/home.dart';
import '../screens/invoice.dart';
import '../screens/login.dart';
import '../screens/order_detail.dart';
import '../screens/orders.dart';
import '../screens/plans.dart';
import '../screens/product.dart';
import '../screens/shop.dart';
import 'theme.dart';

GoRouter buildRouter(AppStore store) => GoRouter(
      refreshListenable: store,
      redirect: (ctx, state) {
        final p = state.matchedLocation;
        if (p.startsWith('/admin') && !store.isAdmin) return '/login';
        if ((p.startsWith('/order') || p == '/checkout') && !store.loggedIn) return '/login';
        return null;
      },
      routes: [
        ShellRoute(
          builder: (c, s, child) => Shell(child: child),
          routes: [
            GoRoute(path: '/', builder: (c, s) => const HomePage()),
            GoRoute(path: '/shop', builder: (c, s) => ShopPage(query: s.uri.queryParameters['q'] ?? '')),
            GoRoute(path: '/cart', builder: (c, s) => const CartPage()),
            GoRoute(path: '/account', builder: (c, s) => const AccountPage()),
          ],
        ),
        GoRoute(path: '/product/:id', builder: (c, s) => ProductPage(id: s.pathParameters['id']!)),
        GoRoute(path: '/checkout', builder: (c, s) => const CheckoutPage()),
        GoRoute(path: '/login', builder: (c, s) => const LoginPage()),
        GoRoute(path: '/plans', builder: (c, s) => const PlansPage()),
        GoRoute(path: '/orders', builder: (c, s) => const OrdersPage()),
        GoRoute(path: '/order/:id', builder: (c, s) => OrderDetailPage(id: s.pathParameters['id']!)),
        GoRoute(path: '/order/:id/invoice', builder: (c, s) => InvoicePage(id: s.pathParameters['id']!)),
        GoRoute(path: '/admin', builder: (c, s) => const AdminDashboard()),
        GoRoute(path: '/admin/products', builder: (c, s) => const AdminProducts()),
        GoRoute(path: '/admin/orders', builder: (c, s) => const AdminOrders()),
        GoRoute(path: '/admin/customers', builder: (c, s) => const AdminCustomers()),
      ],
    );

class Shell extends StatelessWidget {
  final Widget child;
  const Shell({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    final idx = ['/', '/shop', '/cart', '/account'].indexOf(loc).clamp(0, 3);
    final count = context.watch<AppStore>().cartCount;
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => context.go(['/', '/shop', '/cart', '/account'][i]),
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          const NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view), label: 'Shop'),
          NavigationDestination(
              icon: Badge(isLabelVisible: count > 0, label: Text('$count'), backgroundColor: C.lime,
                  textColor: Colors.black, child: const Icon(Icons.shopping_bag_outlined)),
              label: 'Cart'),
          const NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
