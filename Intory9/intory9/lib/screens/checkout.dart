import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../data/store.dart';
import '../widgets/common.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _form = GlobalKey<FormState>();
  final name = TextEditingController(), phone = TextEditingController(), addr = TextEditingController(),
      city = TextEditingController(), pin = TextEditingController();
  String pay = 'UPI';
  static const methods = {
    'UPI': Icons.qr_code_2,
    'Card': Icons.credit_card,
    'Net Banking': Icons.account_balance,
    'Cash on Delivery': Icons.payments_outlined,
  };

  String? req(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  @override
  void dispose() {
    for (final c in [name, phone, addr, city, pin]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppStore>();
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: s.cart.isEmpty
          ? const Center(child: Text('Cart is empty', style: TextStyle(color: C.grey)))
          : Form(
              key: _form,
              child: ListView(padding: const EdgeInsets.all(20), children: [
                const Text('Delivery address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                TextFormField(controller: name, validator: req, decoration: const InputDecoration(hintText: 'Full name')),
                const SizedBox(height: 10),
                TextFormField(
                    controller: phone,
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v ?? '').trim().length == 10 ? null : 'Enter 10-digit number',
                    decoration: const InputDecoration(hintText: 'Phone (10 digits)')),
                const SizedBox(height: 10),
                TextFormField(controller: addr, validator: req, maxLines: 2, decoration: const InputDecoration(hintText: 'House, street, area')),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: TextFormField(controller: city, validator: req, decoration: const InputDecoration(hintText: 'City'))),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextFormField(
                          controller: pin,
                          keyboardType: TextInputType.number,
                          validator: (v) => (v ?? '').trim().length == 6 ? null : '6-digit PIN',
                          decoration: const InputDecoration(hintText: 'PIN code'))),
                ]),
                const SizedBox(height: 24),
                const Text('Payment method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                for (final m in methods.entries)
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: RadioListTile<String>(
                      value: m.key,
                      groupValue: pay,
                      activeColor: C.lime,
                      onChanged: (v) => setState(() => pay = v!),
                      title: Text(m.key),
                      secondary: Icon(m.value, color: C.lime),
                    ),
                  ),
                const SizedBox(height: 16),
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
                FilledButton(
                  onPressed: () {
                    if (!_form.currentState!.validate()) return;
                    final o = s.placeOrder(
                        name: name.text.trim(),
                        phone: phone.text.trim(),
                        address: '${addr.text.trim()}, ${city.text.trim()} - ${pin.text.trim()}',
                        payment: pay);
                    context.go('/order/${o.id}');
                  },
                  child: Text(pay == 'Cash on Delivery' ? 'Place order' : 'Pay ${inr(s.total)}'),
                ),
              ]),
            ),
    );
  }
}
