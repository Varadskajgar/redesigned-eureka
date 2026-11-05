import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class C {
  static const bg = Color(0xFF080D09);
  static const card = Color(0xFF111711);
  static const lime = Color(0xFFB5E532);
  static const grey = Color(0xFF9AA39B);
  static const line = Color(0xFF1E281F);
}

final _money = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
String inr(num v) => _money.format(v);

ThemeData buildTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  final text = GoogleFonts.spaceGroteskTextTheme(base.textTheme)
      .apply(bodyColor: Colors.white, displayColor: Colors.white);
  OutlineInputBorder ob(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: c));
  return base.copyWith(
    scaffoldBackgroundColor: C.bg,
    colorScheme: const ColorScheme.dark(
        primary: C.lime, onPrimary: Colors.black, surface: C.card, secondary: C.lime),
    textTheme: text,
    appBarTheme: AppBarTheme(
        backgroundColor: C.bg,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
    cardTheme: CardTheme(
        color: C.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), side: const BorderSide(color: C.line))),
    filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
            backgroundColor: C.lime,
            foregroundColor: Colors.black,
            minimumSize: const Size(0, 52),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 52),
            side: const BorderSide(color: C.line),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))),
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: C.card,
        hintStyle: const TextStyle(color: C.grey),
        border: ob(C.line),
        enabledBorder: ob(C.line),
        focusedBorder: ob(C.lime)),
    navigationBarTheme: NavigationBarThemeData(
        backgroundColor: C.card,
        indicatorColor: C.lime.withOpacity(.18),
        iconTheme: WidgetStateProperty.resolveWith((s) =>
            IconThemeData(color: s.contains(WidgetState.selected) ? C.lime : C.grey)),
        labelTextStyle: WidgetStateProperty.resolveWith((s) => TextStyle(
            fontSize: 12, color: s.contains(WidgetState.selected) ? C.lime : C.grey))),
    chipTheme: ChipThemeData(
        backgroundColor: C.card,
        selectedColor: C.lime,
        side: const BorderSide(color: C.line),
        labelStyle: const TextStyle(fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
  );
}
