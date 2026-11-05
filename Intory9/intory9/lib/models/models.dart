import 'package:flutter/material.dart';

class Product {
  String id, name, category, desc;
  double price, rating;
  List<String> sizes, colors;
  IconData icon;
  Product(
      {required this.id,
      required this.name,
      required this.category,
      required this.price,
      this.desc = '',
      this.rating = 4.5,
      this.sizes = const ['S', 'M', 'L', 'XL'],
      this.colors = const ['Black', 'White', 'Lime'],
      this.icon = Icons.checkroom});
}

class CartItem {
  final Product product;
  final String size, color;
  int qty;
  CartItem(this.product, this.size, this.color, this.qty);
  double get total => product.price * qty;
}

enum OrderStatus { placed, packed, shipped, outForDelivery, delivered, cancelled }

extension OrderStatusX on OrderStatus {
  String get label => const {
        OrderStatus.placed: 'Order Placed',
        OrderStatus.packed: 'Packed',
        OrderStatus.shipped: 'Shipped',
        OrderStatus.outForDelivery: 'Out for Delivery',
        OrderStatus.delivered: 'Delivered',
        OrderStatus.cancelled: 'Cancelled',
      }[this]!;
}

class Order {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final String customer, phone, address, payment;
  final double subtotal, gst, shipping, total;
  OrderStatus status;
  Order(
      {required this.id,
      required this.date,
      required this.items,
      required this.customer,
      required this.phone,
      required this.address,
      required this.payment,
      required this.subtotal,
      required this.gst,
      required this.shipping,
      required this.total,
      this.status = OrderStatus.placed});
}

class Customer {
  final String name, email;
  final DateTime joined;
  String plan;
  Customer(this.name, this.email, this.joined, {this.plan = 'Free'});
}

class Plan {
  final String name, tagline, period;
  final int price;
  final List<String> perks;
  final bool popular;
  const Plan(this.name, this.tagline, this.price, this.period, this.perks, {this.popular = false});
}
