import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../data/store.dart';
import '../widgets/common.dart';

class ShopPage extends StatefulWidget {
  final String query;
  const ShopPage({super.key, this.query = ''});
  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  static const perPage = 6;
  static const sorts = ['Featured', 'Price: Low to High', 'Price: High to Low', 'Top Rated'];
  late final TextEditingController q = TextEditingController(text: widget.query);
  String cat = 'All', sort = 'Featured';
  int page = 0;

  @override
  void dispose() {
    q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppStore>();
    final all = s.search(q.text, cat, sort);
    final pages = (all.length / perPage).ceil().clamp(1, 999);
    if (page >= pages) page = pages - 1;
    final items = all.skip(page * perPage).take(perPage).toList();
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Shop', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            TextField(
              controller: q,
              onChanged: (_) => setState(() => page = 0),
              decoration: const InputDecoration(hintText: 'Search products', prefixIcon: Icon(Icons.search, color: C.grey)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: s.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (c, i) => ChoiceChip(
                  label: Text(s.categories[i]),
                  selected: cat == s.categories[i],
                  labelStyle: TextStyle(color: cat == s.categories[i] ? Colors.black : Colors.white),
                  onSelected: (_) => setState(() {
                    cat = s.categories[i];
                    page = 0;
                  }),
                ),
              ),
            ),
            Row(children: [
              Text('${all.length} products', style: const TextStyle(color: C.grey)),
              const Spacer(),
              DropdownButton<String>(
                value: sort,
                underline: const SizedBox(),
                dropdownColor: C.card,
                items: sorts.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
                onChanged: (v) => setState(() => sort = v!),
              ),
            ]),
          ]),
        ),
      ),
      if (items.isEmpty)
        const SliverFillRemaining(hasScrollBody: false, child: Center(child: Text('No products found', style: TextStyle(color: C.grey))))
      else
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: .74),
            itemCount: items.length,
            itemBuilder: (c, i) => ProductTile(items[i]),
          ),
        ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(onPressed: page > 0 ? () => setState(() => page--) : null, icon: const Icon(Icons.arrow_back_ios_new, size: 16)),
            for (var i = 0; i < pages; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: ChoiceChip(
                  label: Text('${i + 1}'),
                  selected: page == i,
                  labelStyle: TextStyle(color: page == i ? Colors.black : Colors.white),
                  onSelected: (_) => setState(() => page = i),
                ),
              ),
            IconButton(onPressed: page < pages - 1 ? () => setState(() => page++) : null, icon: const Icon(Icons.arrow_forward_ios, size: 16)),
          ]),
        ),
      ),
    ]);
  }
}
