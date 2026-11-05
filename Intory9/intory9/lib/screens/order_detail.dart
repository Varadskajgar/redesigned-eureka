import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../data/store.dart';
import '../models/models.dart';
import '../widgets/common.dart';

class OrderDetailPage extends StatelessWidget {
  final String id;
  const OrderDetailPage({super.key, required this.id});
  static const steps = [OrderStatus.placed, OrderStatus.packed, OrderStatus.shipped, OrderStatus.outForDelivery, OrderStatus.delivered];

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppStore>();
    final o = s.orderById(id);
    final cur = steps.indexOf(o.status);
    return Scaffold(
      appBar: AppBar(title: Text(o.id), leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/orders'))),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        if (o.status == OrderStatus.cancelled)
          const Card(child: ListTile(leading: Icon(Icons.cancel, color: Colors.redAccent), title: Text('Order cancelled')))
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                for (var i = 0; i < steps.length; i++)
                  Row(children: [
                    Column(children: [
                      Icon(i <= cur ? Icons.check_circle : Icons.radio_button_unchecked, color: i <= cur ? C.lime : C.grey),
                      if (i < steps.length - 1) Container(width: 2, height: 26, color: i < cur ? C.lime : C.line),
                    ]),
                    const SizedBox(width: 14),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 26),
                      child: Text(steps[i].label, style: TextStyle(fontWeight: i == cur ? FontWeight.w800 : FontWeight.w400, color: i <= cur ? Colors.white : C.grey)),
                    ),
                  ]),
              ]),
            ),
          ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              for (final i in o.items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [
                    Expanded(child: Text('${i.product.name}  x${i.qty}\n${i.size} • ${i.color}', style: const TextStyle(height: 1.3))),
                    Text(inr(i.total)),
                  ]),
                ),
              const Divider(color: C.line),
              PriceRow('Subtotal', inr(o.subtotal)),
              PriceRow('GST (18%)', inr(o.gst)),
              PriceRow('Shipping', o.shipping == 0 ? 'FREE' : inr(o.shipping)),
              PriceRow('Total', inr(o.total), bold: true),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.location_on_outlined, color: C.lime),
            title: Text(o.customer),
            subtitle: Text('${o.address}\n${o.phone} • Paid via ${o.payment}'),
            isThreeLine: true,
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(onPressed: () => context.push('/order/${o.id}/invoice'), icon: const Icon(Icons.picture_as_pdf), label: const Text('View / download invoice')),
        if (o.status == OrderStatus.placed) ...[
          const SizedBox(height: 10),
          OutlinedButton(onPressed: () => s.setStatus(o, OrderStatus.cancelled), child: const Text('Cancel order')),
        ],
      ]),
    );
  }
}
