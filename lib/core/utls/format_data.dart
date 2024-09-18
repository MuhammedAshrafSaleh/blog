import 'package:intl/intl.dart';

String formatDateDMMMYYYY(DateTime date) {
  return DateFormat("d MMM, yyyy").format(date);
}
