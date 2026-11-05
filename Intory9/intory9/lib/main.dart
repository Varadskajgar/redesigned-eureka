import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/router.dart';
import 'core/theme.dart';
import 'data/store.dart';

void main() => runApp(ChangeNotifierProvider(create: (_) => AppStore(), child: const IntoryApp()));

class IntoryApp extends StatefulWidget {
  const IntoryApp({super.key});
  @override
  State<IntoryApp> createState() => _IntoryAppState();
}

class _IntoryAppState extends State<IntoryApp> {
  late final GoRouter _router = buildRouter(context.read<AppStore>());
  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Intory9',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        routerConfig: _router,
      );
}
