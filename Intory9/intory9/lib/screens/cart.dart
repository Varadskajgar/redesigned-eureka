import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../data/store.dart';
import '../widgets/common.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppStore>();
    if (s.cart.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.shopping_bag_outlined, size: 64, color: C.grey),
          const SizedBox(height: 12),
          const Text('Your cart is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          FilledButton(onPressed: () => context.go('/shop'), child: const Text('Start shopping')),
        ]),
      );
    }
    return ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Cart', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
      const SizedBox(height: 14),
      for (final i in s.cart)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                SizedBox(width: 78, child: ProductThumb(i.product, height: 78)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(i.product.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text('${i.size} • ${i.color}', style: const TextStyle(color: C.grey, fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(inr(i.total), style: const TextStyle(color: C.lime, fontWeight: FontWeight.w800)),
                  ]),
                ),
                Column(children: [
                  Row(children: [
                    IconButton(visualDensity: VisualDensity.compact, onPressed: () => s.setQty(i, i.qty - 1), icon: const Icon(Icons.remove_circle_outline)),
                    Text('${i.qty}'),
                    IconButton(visualDensity: VisualDensity.compact, onPressed: () => s.setQty(i, i.qty + 1), icon: const Icon(Icons.add_circle_outline)),
                  ]),
                ]),
              ]),
            ),
          ),
        ),
      const SizedBox(height: 8),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            PriceRow('Subtotal', inr(s.subtotal)),
            if (s.memberDiscount > 0) PriceRow('${s.plan} discount', '- ${inr(s.memberDiscount)}'),
            PriceRow('GST (18%)', inr(s.gst)),
            PriceRow('Shipping', s.shipping == 0 ? 'FREE' : inr(s.shipping)),
            const Divider(color: C.line, height: 20),
            PriceRow('Total', inr(s.total), bold: true),
          ]),
        ),
      ),
      const SizedBox(height: 16),
      FilledButton(onPressed: () => context.push('/checkout'), child: const Text('Proceed to checkout')),
    ]);
  }
}
