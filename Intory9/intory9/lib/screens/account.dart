import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../data/store.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppStore>();
    Widget tile(IconData i, String t, String path) => Card(
          child: ListTile(leading: Icon(i, color: C.lime), title: Text(t), trailing: const Icon(Icons.chevron_right, color: C.grey), onTap: () => context.push(path)),
        );
    if (!s.loggedIn) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.person_outline, size: 64, color: C.grey),
            const SizedBox(height: 12),
            const Text('Login to see your account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            FilledButton(onPressed: () => context.push('/login'), child: const Text('Login / Sign up')),
            const SizedBox(height: 10),
            OutlinedButton(onPressed: () => context.push('/plans'), child: const Text('See membership plans')),
          ]),
        ),
      );
    }
    final u = s.user!;
    return ListView(padding: const EdgeInsets.all(20), children: [
      Row(children: [
        CircleAvatar(radius: 32, backgroundColor: C.lime, child: Text(u.name[0].toUpperCase(), style: const TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w900))),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(u.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          Text(u.email, style: const TextStyle(color: C.grey)),
          Text('${s.plan} member', style: const TextStyle(color: C.lime, fontSize: 12)),
        ])),
      ]),
      const SizedBox(height: 22),
      tile(Icons.receipt_long_outlined, 'My orders', '/orders'),
      const SizedBox(height: 10),
      tile(Icons.workspace_premium_outlined, 'Membership', '/plans'),
      if (s.isAdmin) ...[const SizedBox(height: 10), tile(Icons.dashboard_outlined, 'Admin panel', '/admin')],
      const SizedBox(height: 20),
      OutlinedButton(onPressed: () => s.logout(), child: const Text('Logout')),
    ]);
  }
}
