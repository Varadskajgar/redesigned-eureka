import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../data/store.dart';
import '../models/models.dart';

String _rs(num v) => 'Rs. ${NumberFormat('#,##,##0.00', 'en_IN').format(v)}';

Future<Uint8List> buildInvoice(Order o) async {
  final doc = pw.Document();
  const lime = PdfColor.fromInt(0xFF7FA81A);
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(36),
    build: (_) => [
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.RichText(text: pw.TextSpan(children: [
          pw.TextSpan(text: 'Intory', style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
          pw.TextSpan(text: '9', style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, color: lime)),
        ])),
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          pw.Text('TAX INVOICE', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.Text('Invoice #: ${o.id}'),
          pw.Text('Date: ${DateFormat('d MMM y').format(o.date)}'),
        ]),
      ]),
      pw.SizedBox(height: 24),
      pw.Text('Billed to', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.Text(o.customer),
      pw.Text(o.address),
      pw.Text('Phone: ${o.phone}'),
      pw.Text('Payment: ${o.payment}'),
      pw.SizedBox(height: 20),
      pw.TableHelper.fromTextArray(
        headers: ['Item', 'Size/Colour', 'Qty', 'Rate', 'Amount'],
        data: [for (final i in o.items) [i.product.name, '${i.size} / ${i.color}', '${i.qty}', _rs(i.product.price), _rs(i.total)]],
        headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
        headerDecoration: const pw.BoxDecoration(color: PdfColors.grey900),
        cellAlignments: {2: pw.Alignment.center, 3: pw.Alignment.centerRight, 4: pw.Alignment.centerRight},
      ),
      pw.SizedBox(height: 16),
      pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.SizedBox(
          width: 220,
          child: pw.Column(children: [
            _line('Subtotal', _rs(o.subtotal)),
            _line('GST (18%)', _rs(o.gst)),
            _line('Shipping', o.shipping == 0 ? 'FREE' : _rs(o.shipping)),
            pw.Divider(),
            _line('TOTAL', _rs(o.total), bold: true),
          ]),
        ),
      ),
      pw.SizedBox(height: 30),
      pw.Text('Thank you for shopping with Intory9.', style: const pw.TextStyle(color: PdfColors.grey700)),
    ],
  ));
  return doc.save();
}

pw.Widget _line(String a, String b, {bool bold = false}) {
  final st = pw.TextStyle(fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: bold ? 14 : 11);
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text(a, style: st), pw.Text(b, style: st)]),
  );
}

class InvoicePage extends StatelessWidget {
  final String id;
  const InvoicePage({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    final o = context.read<AppStore>().orderById(id);
    return Scaffold(
      appBar: AppBar(title: Text('Invoice ${o.id}'), leading: BackButton(onPressed: () => context.pop())),
      body: PdfPreview(
        build: (_) => buildInvoice(o),
        pdfFileName: 'Intory9-${o.id}.pdf',
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
      ),
    );
  }
}
