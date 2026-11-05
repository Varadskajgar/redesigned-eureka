import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../data/store.dart';
import '../widgets/common.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final name = TextEditingController(), email = TextEditingController(), pass = TextEditingController();
  bool signup = false, hide = true;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/'))),
        body: Form(
          key: _form,
          child: ListView(padding: const EdgeInsets.all(24), children: [
            const Logo(size: 38),
            const SizedBox(height: 8),
            Text(signup ? 'Create your account' : 'Welcome back', style: const TextStyle(color: C.grey, fontSize: 16)),
            const SizedBox(height: 28),
            if (signup) ...[
              TextFormField(controller: name, decoration: const InputDecoration(hintText: 'Full name')),
              const SizedBox(height: 12),
            ],
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v ?? '').contains('@') ? null : 'Enter a valid email',
              decoration: const InputDecoration(hintText: 'Email', prefixIcon: Icon(Icons.mail_outline, color: C.grey)),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: pass,
              obscureText: hide,
              validator: (v) => (v ?? '').length >= 6 ? null : 'Minimum 6 characters',
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline, color: C.grey),
                suffixIcon: IconButton(onPressed: () => setState(() => hide = !hide), icon: Icon(hide ? Icons.visibility_off : Icons.visibility, color: C.grey)),
              ),
            ),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: () {
                if (!_form.currentState!.validate()) return;
                final s = context.read<AppStore>();
                s.login(name.text.trim(), email.text.trim().toLowerCase());
                context.go(s.isAdmin ? '/admin' : '/');
              },
              child: Text(signup ? 'Sign up' : 'Login'),
            ),
            TextButton(
              onPressed: () => setState(() => signup = !signup),
              child: Text(signup ? 'Already have an account? Login' : 'New here? Create account', style: const TextStyle(color: C.lime)),
            ),
            const SizedBox(height: 8),
            const Text('Demo admin: admin@intory9.com (any password, 6+ chars)', textAlign: TextAlign.center, style: TextStyle(color: C.grey, fontSize: 12)),
          ]),
        ),
      );
}
