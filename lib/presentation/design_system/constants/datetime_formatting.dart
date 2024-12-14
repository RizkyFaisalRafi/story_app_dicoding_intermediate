import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  String get toDate {
    return DateFormat("d MMMM yyyy, HH:mm").format(this);
  }
}
