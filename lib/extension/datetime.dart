part of 'export_part.dart';

extension DateTimeCustom on DateTime {
  DateTime onlyYear() => DateTime(year);
  DateTime onlyMonthYear() => DateTime(year, month);
  DateTime onlyDayMonthYear() => DateTime(year, month, day);
  String getTitleMonthYear() {
    return DateFormat('MMMM yyyy').format(this);
  }

  num getTimestamp() {
    return toLocal().millisecondsSinceEpoch ~/ 1000;
  }

  String getYearMonthDay() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String getDayMonthYear() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String getWeekDayMonth() {
    return DateFormat(
      'EEEE dd.MM',
    ).format(this);
  }

  String getMonthDayWeek() {
    return DateFormat(
      'EEEE MM.dd',
    ).format(this);
  }

  String getMonthDayWeekDetail() {
    return DateFormat(
      'MM/dd EEEE',
    ).format(this);
  }

  String getDateTimeFormat(String format) {
    return DateFormat(
      format,
    ).format(this);
  }

  String getTimeOffDay() {
    final TimeOfDay timeOfDay = TimeOfDay(hour: hour, minute: minute);
    return timeOfDay.getString();
  }
}
