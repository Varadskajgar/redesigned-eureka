import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../models/models.dart';

class Logo extends StatelessWidget {
  final double size;
  const Logo({super.key, this.size = 26});
  @override
  Widget build(BuildContext context) => Text.rich(TextSpan(children: [
        TextSpan(
            text: 'Intory',
            style: TextStyle(color: Colors.white, fontSize: size, fontWeight: FontWeight.w800, letterSpacing: -1)),
        TextSpan(text: '9', style: TextStyle(color: C.lime, fontSize: size, fontWeight: FontWeight.w800)),
      ]));
}

class ProductThumb extends StatelessWidget {
  final Product p;
  final double height;
  const ProductThumb(this.p, {super.key, this.height = 150});
  @override
  Widget build(BuildContext context) => Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [C.lime.withOpacity(.16), const Color(0xFF0C120D)]),
        ),
        child: Icon(p.icon, size: height * .42, color: C.lime),
      );
}

class ProductTile extends StatelessWidget {
  final Product p;
  const ProductTile(this.p, {super.key});
  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push('/product/${p.id}'),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(children: [
                ProductThumb(p),
                Positioned(
                    top: 8,
                    left: 8,
                    child: Chip(
                        label: Text(p.category),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        backgroundColor: C.bg)),
              ]),
              const SizedBox(height: 10),
              Text(p.name,
                  maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Row(children: [
                const Icon(Icons.star_rounded, size: 15, color: C.lime),
                Text(' ${p.rating}', style: const TextStyle(color: C.grey, fontSize: 12)),
                const Spacer(),
                Text(inr(p.price), style: const TextStyle(fontWeight: FontWeight.w800, color: C.lime)),
              ]),
            ]),
          ),
        ),
      );
}

class SectionTitle extends StatelessWidget {
  final String text;
  final String? action;
  final VoidCallback? onAction;
  const SectionTitle(this.text, {super.key, this.action, this.onAction});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
        child: Row(children: [
          Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const Spacer(),
          if (action != null) TextButton(onPressed: onAction, child: Text(action!, style: const TextStyle(color: C.lime))),
        ]),
      );
}

class PriceRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  const PriceRow(this.label, this.value, {super.key, this.bold = false});
  @override
  Widget build(BuildContext context) {
    final s = TextStyle(
        fontSize: bold ? 17 : 14, fontWeight: bold ? FontWeight.w800 : FontWeight.w500, color: bold ? C.lime : null);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: s.copyWith(color: bold ? C.lime : C.grey)),
        Text(value, style: s)
      ]),
    );
  }
}

void snack(BuildContext c, String m) => ScaffoldMessenger.of(c)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(
      content: Text(m), behavior: SnackBarBehavior.floating, backgroundColor: C.card, showCloseIcon: true));
