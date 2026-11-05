import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../data/store.dart';
import '../widgets/common.dart';

class PlansPage extends StatelessWidget {
  const PlansPage({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppStore>();
    return Scaffold(
      appBar: AppBar(title: const Text('Membership'), leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/'))),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const Text('Pick your plan', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const Text('Upgrade or cancel anytime.', style: TextStyle(color: C.grey)),
        const SizedBox(height: 18),
        for (final p in AppStore.plans)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: C.card,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: p.popular ? C.lime : C.line, width: p.popular ? 1.6 : 1),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(p.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(width: 8),
                  if (p.popular)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(color: C.lime, borderRadius: BorderRadius.circular(20)),
                      child: const Text('Popular', style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w800)),
                    ),
                ]),
                Text(p.tagline, style: const TextStyle(color: C.grey)),
                const SizedBox(height: 10),
                Text.rich(TextSpan(children: [
                  TextSpan(text: p.price == 0 ? 'Free' : inr(p.price), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                  TextSpan(text: '  / ${p.period}', style: const TextStyle(color: C.grey)),
                ])),
                const SizedBox(height: 14),
                for (final f in p.perks)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(children: [const Icon(Icons.verified, size: 18, color: C.lime), const SizedBox(width: 10), Expanded(child: Text(f))]),
                  ),
                const SizedBox(height: 14),
                s.plan == p.name
                    ? const OutlinedButton(onPressed: null, child: Text('Current plan'))
                    : FilledButton(
                        onPressed: () {
                          if (!s.loggedIn) return context.push('/login');
                          s.subscribe(p.name);
                          snack(context, 'You are now on ${p.name}');
                        },
                        child: Text(p.price == 0 ? 'Switch to Free' : 'Upgrade now'),
                      ),
              ]),
            ),
          ),
      ]),
    );
  }
}
