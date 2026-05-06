import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  static final _formatter = DateFormat('dd.MM.yyyy');

  // TODO: Add tests
  String format() => _formatter.format(this);
}
