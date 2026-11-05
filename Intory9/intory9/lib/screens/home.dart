import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../data/store.dart';
import '../widgets/common.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppStore>();
    final trending = [...s.products]..sort((a, b) => b.rating.compareTo(a.rating));
    return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Row(children: [
          const Logo(),
          const Spacer(),
          IconButton(onPressed: () => context.push('/orders'), icon: const Icon(Icons.receipt_long_outlined)),
        ]),
      ),
      // Hero
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          builder: (c, v, child) => Opacity(opacity: v, child: Transform.translate(offset: Offset(0, 24 * (1 - v)), child: child)),
          child: Container(
            height: 230,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [C.lime.withOpacity(.22), C.card]),
              border: Border.all(color: C.line),
            ),
            child: Stack(children: [
              const Positioned(right: -10, top: -6, child: Icon(Icons.bolt_rounded, size: 150, color: C.lime)),
              Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                const Text('Shop', style: TextStyle(fontSize: 72, height: .95, fontWeight: FontWeight.w900, letterSpacing: -3)),
                const SizedBox(height: 4),
                const Text('Give all you need.', style: TextStyle(color: C.grey, fontSize: 16)),
              ]),
            ]),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
        child: TextField(
          textInputAction: TextInputAction.search,
          onSubmitted: (q) => context.go('/shop?q=${Uri.encodeComponent(q)}'),
          decoration: const InputDecoration(hintText: 'Search on Intory9', prefixIcon: Icon(Icons.search, color: C.grey)),
        ),
      ),
      const SectionTitle('Categories'),
      SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: s.categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (c, i) => ActionChip(label: Text(s.categories[i]), onPressed: () => context.go('/shop?q=')),
        ),
      ),
      SectionTitle('Trending', action: 'See all', onAction: () => context.go('/shop')),
      SizedBox(
        height: 250,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: trending.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (c, i) => SizedBox(width: 170, child: ProductTile(trending[i])),
        ),
      ),
      // Membership banner
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
        child: InkWell(
          onTap: () => context.push('/plans'),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(color: C.lime, borderRadius: BorderRadius.circular(24)),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                  Text('Intory9 Membership', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w900)),
                  SizedBox(height: 6),
                  Text('Free shipping, early drops and up to 12% off.', style: TextStyle(color: Colors.black87)),
                ]),
              ),
              const Icon(Icons.arrow_forward_rounded, color: Colors.black, size: 30),
            ]),
          ),
        ),
      ),
      // Newsletter
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: C.card, borderRadius: BorderRadius.circular(24), border: Border.all(color: C.line)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Ready to get\nyour new stuff?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.1)),
            const SizedBox(height: 14),
            _Newsletter(),
          ]),
        ),
      ),
      // Footer
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 32, 20, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Logo(size: 22),
          SizedBox(height: 8),
          Text('About  •  Support  •  Shipping  •  Returns  •  FAQ', style: TextStyle(color: C.grey, fontSize: 13)),
          SizedBox(height: 8),
          Text('© 2026 Intory9. All rights reserved.', style: TextStyle(color: C.grey, fontSize: 12)),
        ]),
      ),
    ]);
  }
}

class _Newsletter extends StatefulWidget {
  @override
  State<_Newsletter> createState() => _NewsletterState();
}

class _NewsletterState extends State<_Newsletter> {
  final c = TextEditingController();
  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(child: TextField(controller: c, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(hintText: 'Your email'))),
        const SizedBox(width: 10),
        FilledButton(
          onPressed: () {
            if (!c.text.contains('@')) return snack(context, 'Enter a valid email');
            c.clear();
            snack(context, 'Subscribed. Welcome to Intory9!');
          },
          child: const Text('Send'),
        ),
      ]);
}
