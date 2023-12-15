part of 'export_part.dart';

extension TimeOffDayCustom on TimeOfDay {
  String getString() {
    final int hourTemp = hour > 12 ? hour - 12 : hour;
    final type = hour > 12 ? "PM" : "AM";
    return "${hourTemp >= 10 ? hourTemp : "0$hourTemp"} : ${minute >= 10 ? minute : "0$minute"} $type";
  }
}
