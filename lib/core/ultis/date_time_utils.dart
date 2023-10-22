import 'package:intl/intl.dart';

String convertHour(String originalTimeString) {
  DateTime originalTime = DateTime.parse(originalTimeString);
  String formattedTime = DateFormat.jm().format(originalTime);
  return formattedTime;
}