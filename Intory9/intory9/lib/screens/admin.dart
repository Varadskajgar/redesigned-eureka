import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../data/store.dart';
import '../models/models.dart';
import '../widgets/common.dart';

class AdminScaffold extends StatelessWidget {
  final String title;
  final int index;
  final Widget body;
  final Widget? fab;
  const AdminScaffold({super.key, required this.title, required this.index, required this.body, this.fab});
  static const paths = ['/admin', '/admin/products', '/admin/orders', '/admin/customers'];
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Row(children: [const Logo(size: 22), const SizedBox(width: 8), Text(title, style: const TextStyle(color: C.grey, fontSize: 16))]),
          actions: [IconButton(onPressed: () => context.go('/account'), icon: const Icon(Icons.storefront_outlined))],
        ),
        body: body,
        floatingActionButton: fab,
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => context.go(paths[i]),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
            NavigationDestination(icon: Icon(Icons.inventory_2_outlined), label: 'Products'),
            NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Orders'),
            NavigationDestination(icon: Icon(Icons.people_outline), label: 'Customers'),
          ],
        ),
      );
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppStore>();
    Widget stat(String l, String v, IconData i) => Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(i, color: C.lime),
              const SizedBox(height: 10),
              Text(v, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              Text(l, style: const TextStyle(color: C.grey, fontSize: 12)),
            ]),
          ),
        );
    return AdminScaffold(
      title: 'Dashboard',
      index: 0,
      body: ListView(padding: const EdgeInsets.all(20), children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            stat('Revenue', inr(s.revenue), Icons.payments_outlined),
            stat('Orders', '${s.orders.length}', Icons.receipt_long_outlined),
            stat('Products', '${s.products.length}', Icons.inventory_2_outlined),
            stat('Customers', '${s.customers.length}', Icons.people_outline),
          ],
        ),
        const SectionTitle('Recent orders'),
        if (s.orders.isEmpty) const Text('No orders yet', style: TextStyle(color: C.grey)),
        for (final o in s.orders.take(5))
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(o.id),
              subtitle: Text('${o.customer} • ${o.status.label}'),
              trailing: Text(inr(o.total), style: const TextStyle(color: C.lime, fontWeight: FontWeight.w800)),
            ),
          ),
      ]),
    );
  }
}

class AdminProducts extends StatelessWidget {
  const AdminProducts({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppStore>();
    return AdminScaffold(
      title: 'Products',
      index: 1,
      fab: FloatingActionButton(backgroundColor: C.lime, foregroundColor: Colors.black, onPressed: () => _edit(context, s, null), child: const Icon(Icons.add)),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 90), children: [
        for (final p in s.products)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(p.icon, color: C.lime),
              title: Text(p.name),
              subtitle: Text('${p.category} • ${inr(p.price)}'),
              onTap: () => _edit(context, s, p),
              trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => s.deleteProduct(p.id)),
            ),
          ),
      ]),
    );
  }

  void _edit(BuildContext context, AppStore s, Product? p) {
    final name = TextEditingController(text: p?.name ?? '');
    final price = TextEditingController(text: p == null ? '' : p.price.toStringAsFixed(0));
    final desc = TextEditingController(text: p?.desc ?? '');
    String cat = p?.category ?? s.categories[1];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: C.card,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(p == null ? 'Add product' : 'Edit product', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            TextField(controller: name, decoration: const InputDecoration(hintText: 'Name')),
            const SizedBox(height: 10),
            TextField(controller: price, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Price (INR)')),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: cat,
              dropdownColor: C.card,
              items: s.categories.skip(1).map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => set(() => cat = v!),
            ),
            const SizedBox(height: 10),
            TextField(controller: desc, maxLines: 2, decoration: const InputDecoration(hintText: 'Description')),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final pr = double.tryParse(price.text);
                  if (name.text.trim().isEmpty || pr == null) return;
                  if (p == null) {
                    s.saveProduct(Product(id: 'p${DateTime.now().millisecondsSinceEpoch}', name: name.text.trim(), category: cat, price: pr, desc: desc.text.trim()));
                  } else {
                    p.name = name.text.trim();
                    p.price = pr;
                    p.category = cat;
                    p.desc = desc.text.trim();
                    s.saveProduct(p);
                  }
                  Navigator.pop(ctx);
                },
                child: const Text('Save'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class AdminOrders extends StatelessWidget {
  const AdminOrders({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppStore>();
    return AdminScaffold(
      title: 'Orders',
      index: 2,
      body: s.orders.isEmpty
          ? const Center(child: Text('No orders yet', style: TextStyle(color: C.grey)))
          : ListView(padding: const EdgeInsets.all(20), children: [
              for (final o in s.orders)
                Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text(o.id, style: const TextStyle(fontWeight: FontWeight.w800)),
                        const Spacer(),
                        Text(inr(o.total), style: const TextStyle(color: C.lime, fontWeight: FontWeight.w800)),
                      ]),
                      Text('${o.customer} • ${o.payment} • ${DateFormat('d MMM').format(o.date)}', style: const TextStyle(color: C.grey, fontSize: 12)),
                      const SizedBox(height: 8),
                      DropdownButton<OrderStatus>(
                        value: o.status,
                        isExpanded: true,
                        dropdownColor: C.card,
                        underline: const SizedBox(),
                        items: OrderStatus.values.map((e) => DropdownMenuItem(value: e, child: Text(e.label))).toList(),
                        onChanged: (v) => s.setStatus(o, v!),
                      ),
                    ]),
                  ),
                ),
            ]),
    );
  }
}

class AdminCustomers extends StatelessWidget {
  const AdminCustomers({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppStore>();
    return AdminScaffold(
      title: 'Customers',
      index: 3,
      body: ListView(padding: const EdgeInsets.all(20), children: [
        for (final c in s.customers)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: C.lime, child: Text(c.name[0].toUpperCase(), style: const TextStyle(color: Colors.black))),
              title: Text(c.name),
              subtitle: Text('${c.email}\nJoined ${DateFormat('d MMM y').format(c.joined)}'),
              isThreeLine: true,
              trailing: Chip(label: Text(c.plan), visualDensity: VisualDensity.compact),
            ),
          ),
      ]),
    );
  }
}
