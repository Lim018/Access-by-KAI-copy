import 'dart:io';
import 'package:flutter/foundation.dart'; // BARU: Diperlukan untuk mendeteksi platform (kIsWeb)
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../models/booking_data.dart';
import 'package:intl/intl.dart';

// BARU: Import 'dart:html' hanya untuk platform web
// Ini diperlukan untuk memicu download di browser
import 'dart:html' as html;

class PdfService {
  static Future<pw.Document> _createPdf(BookingData bookingData, String bookingId) async {
    final pdf = pw.Document();
    final train = bookingData.selectedTrain!;
    final passenger = bookingData.passengerData!;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          // Konten PDF tetap sama, tidak perlu diubah
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Boarding Pass - Kereta Api',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Detail Perjalanan',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Kereta:'),
                  pw.Text('${train['trainName']} (${train['trainCode']})'),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Rute:'),
                  pw.Text('${bookingData.from} → ${bookingData.to}'),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Tanggal:'),
                  pw.Text(DateFormat('EEE, dd MMM yyyy').format(DateTime.parse(bookingData.departureDate))),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Waktu:'),
                  pw.Text('${train['departure']} - ${train['arrival']}'),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Data Penumpang',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Nama:'),
                  pw.Text(passenger['fullName']),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('No. Identitas:'),
                  pw.Text(passenger['idNumber']),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Kursi:'),
                  pw.Text(bookingData.selectedSeats!.join(', ')),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Center(
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: 'booking_id:$bookingId',
                  width: 150,
                  height: 150,
                ),
              ),
              pw.Center(
                child: pw.Text('Booking ID: $bookingId'),
              ),
              pw.Spacer(),
              pw.Footer(
                title: pw.Text('Terima kasih telah menggunakan layanan kami.'),
              ),
            ],
          );
        },
      ),
    );
    return pdf;
  }

  static Future<void> createAndSharePdf(BookingData bookingData, String bookingId) async {
    // Fungsi share tidak direkomendasikan untuk web, jadi kita fokus pada download
    if (kIsWeb) {
      // Di web, 'share' tidak praktis, jadi kita panggil fungsi download saja.
      await savePdfToDownloads(null, bookingData, bookingId);
      return;
    }

    final pdf = await _createPdf(bookingData, bookingId);
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/boarding_pass_$bookingId.pdf");
    await file.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(file.path)], text: 'Ini adalah e-ticket Anda.');
  }

  // --- PERUBAHAN UTAMA DI SINI ---
  static Future<void> savePdfToDownloads(BuildContext? context, BookingData bookingData, String bookingId) async {
    try {
      final pdf = await _createPdf(bookingData, bookingId);
      final pdfBytes = await pdf.save();
      final fileName = 'boarding_pass_$bookingId.pdf';

      if (kIsWeb) {
        // --- LOGIKA UNTUK WEB ---
        final blob = html.Blob([pdfBytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", fileName)
          ..click();
        html.Url.revokeObjectUrl(url);

      } else {
        // --- LOGIKA UNTUK MOBILE (Android/iOS) ---
        final directory = await getDownloadsDirectory();
        if (directory == null) {
          if (context != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tidak dapat menemukan folder Downloads.')),
            );
          }
          return;
        }

        final filePath = "${directory.path}/$fileName";
        final file = File(filePath);
        await file.writeAsBytes(pdfBytes);

        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('PDF berhasil disimpan di folder Downloads.'),
              action: SnackBarAction(label: 'OK', onPressed: () {}),
            ),
          );
        }
      }
    } catch (e) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan PDF: $e')),
        );
      }
    }
  }
}