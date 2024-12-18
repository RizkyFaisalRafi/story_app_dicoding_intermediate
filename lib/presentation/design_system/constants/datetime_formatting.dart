import 'package:intl/intl.dart';

// extension DateTimeFormatting on DateTime {
//   String get toDate {
//     return DateFormat("d MMMM yyyy, HH:mm").format(this);
//   }
// }

extension DateTimeFormatting on DateTime {
  String toLocalizedDate(String locale) {
    return DateFormat("d MMMM yyyy, HH:mm", locale).format(this);
  }
}
