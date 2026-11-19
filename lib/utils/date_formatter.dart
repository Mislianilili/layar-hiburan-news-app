import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  /// Mengubah ISO-8601 menjadi contoh: "18 Nov 2026, 07:30".
  /// Pastikan initializeDateFormatting('id_ID') sudah dipanggil di main().
  static String formatDate(String iso) {
    if (iso.isEmpty) return '-';
    final tanggal = DateTime.tryParse(iso);
    if (tanggal == null) return iso;
    return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(tanggal.toLocal());
  }
}
