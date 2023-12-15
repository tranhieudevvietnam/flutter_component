import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_component/extension/export_part.dart';
import 'package:flutter_component/widgets/widget_animation_click.dart';

showWidgetDateTimePicker({
  required BuildContext context,
  DateTime? current,
  bool checkCurrentDate = false,
  required Function(DateTime value) onSelected,
  TextStyle? textStyle,
  TextStyle? weekdayTitleStyle,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetAnimationCurve: Curves.bounceIn,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: WidgetDatePicker(
              checkCurrentDate: checkCurrentDate,
              onSelected: onSelected,
              current: current,
              textStyle: textStyle,
              weekdayTitleStyle: weekdayTitleStyle,
            )),
      );
    },
  );
}

class WidgetDatePicker extends StatefulWidget {
  const WidgetDatePicker({
    Key? key,
    required this.onSelected,
    this.current,
    required this.checkCurrentDate,
    this.textStyle,
    this.weekdayTitleStyle,
  }) : super(key: key);
  final Function(DateTime value) onSelected;
  final DateTime? current;
  final bool checkCurrentDate;
  final TextStyle? textStyle;
  final TextStyle? weekdayTitleStyle;
  @override
  State<WidgetDatePicker> createState() => _WidgetDatePickerState();
}

class _WidgetDatePickerState extends State<WidgetDatePicker> {
  final _lsWeekDay = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  late DateTime dateSelected;
  late DateTime currentDateTime;
  @override
  void initState() {
    currentDateTime = widget.current ?? DateTime.now();
    dateSelected = widget.current ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () {
                  currentDateTime = DateTime(currentDateTime.year, currentDateTime.month - 1);
                  setState(() {});
                },
                child: _buildIcon(Icons.navigate_before)),
            Text(
              currentDateTime.getTitleMonthYear(),
              style: widget.textStyle ?? const TextStyle(fontWeight: FontWeight.w700),
            ),
            WidgetAnimationClick(
                onTap: () {
                  currentDateTime = DateTime(currentDateTime.year, currentDateTime.month + 1);
                  setState(() {});
                },
                child: _buildIcon(Icons.navigate_next)),
          ],
        ),
        CalendarMonthView(
          dateTime: currentDateTime,
          weekdayTitle: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: List.generate(
                _lsWeekDay.length,
                (index) => Expanded(
                  child: Text(
                    _lsWeekDay[index],
                    textAlign: TextAlign.center,
                    // style: StyleFont.medium(14).copyWith(color: Colors.grey),
                    style: widget.weekdayTitleStyle ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
          itemCalendarBuilder: (context, DateTime date, index) {
            return WidgetCalendarItem(
              onTap: () {
                dateSelected = date;
                widget.onSelected.call(date);
                Navigator.of(context).pop();
              },
              checkCurrentDate: widget.checkCurrentDate,
              day: date,
              onValidateSelected: () {
                final checkSelected = dateSelected.onlyDayMonthYear().difference(date.onlyDayMonthYear()).inDays;
                return checkSelected == 0;
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildIcon(IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16).copyWith(left: 4, right: 4),
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFDDDDDD)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Icon(icon),
    );
  }
}

class WidgetCalendarItem extends StatelessWidget {
  const WidgetCalendarItem({
    Key? key,
    required this.day,
    required this.onValidateSelected,
    required this.checkCurrentDate,
    this.onTap,
    this.colorSelected,
    this.textStyle,
  }) : super(key: key);
  final DateTime day;
  final bool checkCurrentDate;
  final bool Function() onValidateSelected;
  final Function()? onTap;
  final Color? colorSelected;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (eventCheckCurrentDate(day)) {
          onTap?.call();
        }
      },
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 36,
          width: 36,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: onValidateSelected.call() == true ? colorSelected ?? Colors.red : Colors.white,
              border: Border.all(
                  color: onValidateSelected.call() == true
                      ? colorSelected ?? Colors.red
                      : DateTime.now().onlyDayMonthYear().difference(day.onlyDayMonthYear()).inDays == 0
                          ? colorSelected ?? Colors.red
                          : Colors.white)),
          child: Center(
            child: Text(
              "${day.day}",
              style: (textStyle ?? const TextStyle(fontSize: 14)).copyWith(
                  color: onValidateSelected.call() == true
                      ? Colors.white
                      : eventCheckCurrentDate(day)
                          ? Colors.black
                          : Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  eventCheckCurrentDate(DateTime date) {
    if (checkCurrentDate == true) {
      if (DateTime.now().onlyDayMonthYear().difference(date).inDays > 0) {
        return false;
      }
      return true;
    }
    return true;
  }
}
