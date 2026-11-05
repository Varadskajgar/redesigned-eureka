import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../data/store.dart';

Color statusColor(s) => s.label == 'Cancelled' ? Colors.redAccent : C.lime;

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppStore>();
    return Scaffold(
      appBar: AppBar(title: const Text('My orders'), leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/'))),
      body: s.orders.isEmpty
          ? const Center(child: Text('No orders yet', style: TextStyle(color: C.grey)))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: s.orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (c, i) {
                final o = s.orders[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => context.push('/order/${o.id}'),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Text(o.id, style: const TextStyle(fontWeight: FontWeight.w800)),
                          const Spacer(),
                          Text(o.status.label, style: TextStyle(color: statusColor(o.status), fontWeight: FontWeight.w700)),
                        ]),
                        const SizedBox(height: 6),
                        Text('${DateFormat('d MMM y').format(o.date)} • ${o.items.length} item(s)', style: const TextStyle(color: C.grey, fontSize: 13)),
                        const SizedBox(height: 6),
                        Text(inr(o.total), style: const TextStyle(color: C.lime, fontWeight: FontWeight.w800, fontSize: 16)),
                      ]),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
