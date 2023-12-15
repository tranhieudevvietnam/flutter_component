import 'package:date_time_picker/extension.dart';
import 'package:flutter/material.dart';

typedef BuildItemCalendar<T> = Widget Function(BuildContext context, DateTime date, int index);

// ignore: must_be_immutable
class CalendarMonthView extends StatelessWidget {
  CalendarMonthView({
    super.key,
    required this.dateTime,
    required this.weekdayTitle,
    required this.itemCalendarBuilder,
  });

  final DateTime dateTime;
  final Widget weekdayTitle;
  final BuildItemCalendar itemCalendarBuilder;

  int? dayUpdate;
  int dayForFirstRow = 0;
  DateTime myDateAfterPlus = DateTime.now().subtract(Duration(days: DateTime.now().daysInMonth()));
  final maxRowsNumber = 5;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ..._buildListOfRow(context),
      ],
    );
  }

  List<Widget> _buildListOfRow(
    BuildContext context,
  ) {
    var firstWeekday = dateTime.copyWith(day: 1).weekday;
    final List<Widget> rows = <Widget>[];
    rows.add(weekdayTitle);

    rows.add(
      _buildFirstRow(weekday: firstWeekday, dateTimeDefault: dateTime, context: context),
    );

    DateTime date = DateTime(dateTime.year, dateTime.month, dayForFirstRow + 1);

    for (var i = 0; i < maxRowsNumber; i++) {
      if (dayUpdate != null) {
        date = DateTime(dateTime.year, dateTime.month, dayUpdate!);
      }
      // if (myDateAfterPlus.month <= date.month && myDateAfterPlus.day != 1) {
      rows.add(_buildRow(
        dateTimeDefault: date,
        context: context,
      ));
      // }
    }

    return rows;
  }

  Widget _buildRow({
    required DateTime dateTimeDefault,
    required BuildContext context,
  }) {
    List<Widget> widget = [];
    myDateAfterPlus = dateTimeDefault;

    for (int i = 0; i < 7; i++) {
      // checking when month is 12
      if (myDateAfterPlus.day == 1) {
        widget.add(const Expanded(child: SizedBox()));
        continue;
      }
      if (myDateAfterPlus.month > dateTimeDefault.month) {
        widget.add(const Expanded(child: SizedBox()));
      } else {
        widget.add(Expanded(child: itemCalendarBuilder.call(context, myDateAfterPlus, i)));
      }
      myDateAfterPlus = myDateAfterPlus.add(const Duration(days: 1));
    }

    dayUpdate = myDateAfterPlus.day;

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: widget,
    );
  }

  Widget _buildFirstRow({int weekday = 0, required DateTime dateTimeDefault, required BuildContext context}) {
    List<Widget> widget = [];
    int day = 0;
    for (int i = 0; i < 7; i++) {
      if ((weekday - 1) <= i) {
        final dividedNumber = i - weekday;
        day = dividedNumber + 2;
        final date = DateTime(dateTimeDefault.year, dateTimeDefault.month, day);
        widget.add(Expanded(child: itemCalendarBuilder.call(context, date, i)));
      } else {
        widget.add(const Expanded(child: SizedBox()));
      }
    }
    dayForFirstRow = day;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: widget,
    );
  }
}
