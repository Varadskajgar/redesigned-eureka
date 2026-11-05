import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../data/store.dart';
import '../widgets/common.dart';

class ProductPage extends StatefulWidget {
  final String id;
  const ProductPage({super.key, required this.id});
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String? size, color;
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppStore>();
    final p = s.byId(widget.id);
    size ??= p.sizes.first;
    color ??= p.colors.first;
    void add() => s.addToCart(p, size!, color!, qty);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/')),
        actions: [IconButton(onPressed: () => context.go('/cart'), icon: const Icon(Icons.shopping_bag_outlined))],
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 24), children: [
        ProductThumb(p, height: 320),
        const SizedBox(height: 18),
        Text(p.category.toUpperCase(), style: const TextStyle(color: C.lime, letterSpacing: 2, fontSize: 12)),
        const SizedBox(height: 4),
        Text(p.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Row(children: [
          const Icon(Icons.star_rounded, color: C.lime, size: 18),
          Text(' ${p.rating}', style: const TextStyle(color: C.grey)),
          const Spacer(),
          Text(inr(p.price), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: C.lime)),
        ]),
        const SizedBox(height: 14),
        Text(p.desc, style: const TextStyle(color: C.grey, height: 1.5)),
        const SizedBox(height: 22),
        const Text('Size', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: [
          for (final z in p.sizes)
            ChoiceChip(
              label: Text(z),
              selected: size == z,
              labelStyle: TextStyle(color: size == z ? Colors.black : Colors.white),
              onSelected: (_) => setState(() => size = z),
            ),
        ]),
        const SizedBox(height: 16),
        const Text('Colour', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: [
          for (final z in p.colors)
            ChoiceChip(
              label: Text(z),
              selected: color == z,
              labelStyle: TextStyle(color: color == z ? Colors.black : Colors.white),
              onSelected: (_) => setState(() => color = z),
            ),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w700)),
          const Spacer(),
          IconButton.outlined(onPressed: qty > 1 ? () => setState(() => qty--) : null, icon: const Icon(Icons.remove)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('$qty', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
          IconButton.outlined(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add)),
        ]),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                add();
                snack(context, 'Added to cart');
              },
              child: const Text('Add to cart'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: () {
                add();
                context.push('/checkout');
              },
              child: const Text('Buy now'),
            ),
          ),
        ]),
      ]),
    );
  }
}
