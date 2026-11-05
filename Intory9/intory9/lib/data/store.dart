import 'package:flutter/material.dart';
import '../models/models.dart';

/// App state (local, in-memory). Replace the methods with Supabase/REST calls
/// using database/schema.sql when you connect a real backend.
class AppStore extends ChangeNotifier {
  static const adminEmail = 'admin@intory9.com';
  static const gstRate = 0.18;
  static const freeShipAbove = 999.0;
  static const shipFee = 79.0;

  final categories = ['All', 'Hoodies', 'Tees', 'Pants', 'Shoes', 'Caps', 'Bags'];

  final List<Product> products = [
    Product(id: 'p1', name: 'Neon Core Hoodie', category: 'Hoodies', price: 2499, rating: 4.8,
        icon: Icons.checkroom, desc: 'Heavyweight fleece hoodie with lime stitching. Oversized premium fit.'),
    Product(id: 'p2', name: 'Midnight Tee', category: 'Tees', price: 899, rating: 4.6,
        icon: Icons.dry_cleaning, desc: '240 GSM combed cotton tee. Soft, boxy, built for daily wear.'),
    Product(id: 'p3', name: 'Shadow Cargo Pants', category: 'Pants', price: 1999, rating: 4.7,
        icon: Icons.accessibility_new, sizes: ['28', '30', '32', '34', '36'],
        desc: 'Relaxed cargo with six pockets and a tapered ankle.'),
    Product(id: 'p4', name: 'Volt Runner Shoes', category: 'Shoes', price: 3999, rating: 4.9,
        icon: Icons.directions_run, sizes: ['6', '7', '8', '9', '10', '11'],
        desc: 'Lightweight runners with cushioned sole and breathable mesh.'),
    Product(id: 'p5', name: 'Pulse Snapback Cap', category: 'Caps', price: 599, rating: 4.4,
        icon: Icons.sports_baseball, sizes: ['Free'], desc: 'Structured snapback with embroidered 9 logo.'),
    Product(id: 'p6', name: 'Stealth Sling Bag', category: 'Bags', price: 1299, rating: 4.5,
        icon: Icons.backpack, sizes: ['One Size'], desc: 'Water-resistant sling with hidden zip pocket.'),
  ];

  final List<CartItem> cart = [];
  final List<Order> orders = [];
  final List<Customer> customers = [
    Customer('Aarav Sharma', 'aarav@mail.com', DateTime(2026, 9, 12), plan: 'Plus'),
    Customer('Riya Verma', 'riya@mail.com', DateTime(2026, 10, 3)),
    Customer('Kabir Singh', 'kabir@mail.com', DateTime(2026, 10, 21), plan: 'Pro'),
  ];

  static const plans = [
    Plan('Free', 'For casual shoppers', 0, 'forever',
        ['Standard shipping', 'Order tracking', 'Email support']),
    Plan('Plus', 'For regular buyers', 199, 'month',
        ['Free shipping on all orders', 'Early access to drops', '5% member discount', 'Priority support'],
        popular: true),
    Plan('Pro', 'For true fans', 499, 'month',
        ['Everything in Plus', '12% member discount', 'Free returns', 'Exclusive Pro drops', '24/7 chat support']),
  ];

  Customer? user;
  String plan = 'Free';
  bool get loggedIn => user != null;
  bool get isAdmin => user?.email == adminEmail;

  // ---- auth
  void login(String name, String email) {
    final existing = customers.where((c) => c.email == email).toList();
    if (existing.isNotEmpty) {
      user = existing.first;
    } else {
      user = Customer(name.isEmpty ? email.split('@').first : name, email, DateTime.now());
      if (email != adminEmail) customers.add(user!);
    }
    plan = user!.plan;
    notifyListeners();
  }

  void logout() {
    user = null;
    plan = 'Free';
    notifyListeners();
  }

  void subscribe(String p) {
    plan = p;
    user?.plan = p;
    notifyListeners();
  }

  // ---- catalog
  Product byId(String id) => products.firstWhere((p) => p.id == id);

  List<Product> search(String q, String cat, String sort) {
    final l = products
        .where((p) => (cat == 'All' || p.category == cat) && p.name.toLowerCase().contains(q.toLowerCase()))
        .toList();
    switch (sort) {
      case 'Price: Low to High':
        l.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        l.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Top Rated':
        l.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return l;
  }

  void saveProduct(Product p) {
    final i = products.indexWhere((x) => x.id == p.id);
    i == -1 ? products.add(p) : products[i] = p;
    notifyListeners();
  }

  void deleteProduct(String id) {
    products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // ---- cart
  int get cartCount => cart.fold(0, (s, i) => s + i.qty);
  double get subtotal => cart.fold(0.0, (s, i) => s + i.total);
  double get memberDiscount => subtotal * (plan == 'Pro' ? .12 : plan == 'Plus' ? .05 : 0);
  double get taxable => subtotal - memberDiscount;
  double get gst => taxable * gstRate;
  double get shipping => cart.isEmpty || plan != 'Free' || taxable >= freeShipAbove ? 0 : shipFee;
  double get total => taxable + gst + shipping;

  void addToCart(Product p, String size, String color, int qty) {
    final i = cart.indexWhere((c) => c.product.id == p.id && c.size == size && c.color == color);
    i == -1 ? cart.add(CartItem(p, size, color, qty)) : cart[i].qty += qty;
    notifyListeners();
  }

  void setQty(CartItem c, int q) {
    q <= 0 ? cart.remove(c) : c.qty = q;
    notifyListeners();
  }

  // ---- orders
  Order placeOrder(
      {required String name, required String phone, required String address, required String payment}) {
    final o = Order(
        id: 'INT9-${1000 + orders.length + 1}',
        date: DateTime.now(),
        items: List.of(cart),
        customer: name,
        phone: phone,
        address: address,
        payment: payment,
        subtotal: taxable,
        gst: gst,
        shipping: shipping,
        total: total);
    orders.insert(0, o);
    cart.clear();
    notifyListeners();
    return o;
  }

  Order orderById(String id) => orders.firstWhere((o) => o.id == id);

  void setStatus(Order o, OrderStatus s) {
    o.status = s;
    notifyListeners();
  }

  double get revenue =>
      orders.where((o) => o.status != OrderStatus.cancelled).fold(0.0, (s, o) => s + o.total);
}
