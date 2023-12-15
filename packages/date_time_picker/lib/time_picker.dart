import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePickerWidget extends StatefulWidget {
  final Function(String) onChange;
  final TextStyle? timeStyle;

  const TimePickerWidget({Key? key, required this.onChange,  this.timeStyle}) : super(key: key);
  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  Widget durationPicker({bool inMinutes = false}) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: 0),
      backgroundColor: Colors.white,
      onSelectedItemChanged: (x) {
        if (inMinutes) {
          currentTimeInMin = x.toString();
        } else {
          currentTimeInHour = x.toString();
        }
        setState(() {});
        widget.onChange('$currentTimeInHour Hr $currentTimeInMin mins');
      },
      itemExtent: 50,
      children: List.generate(
          inMinutes ? 60 : 24,
          (index) => Text(inMinutes ? '$index mins' : '$index Hr',
              style: const TextStyle(color: Colors.black))),
    );
  }
  // _buildHr(String value){
  //   return Text(value, style: widget.timeStyle,);
  // }
  String currentTimeInHour = '';
  String currentTimeInMin = '';
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Custom Time Picker',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            const Text(
              'Scroll the list to pick the time.',
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: RichText(
                  text: TextSpan(
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      children: [
                        const TextSpan(
                          text: 'Selected: ',
                        ),
                        TextSpan(
                            style: const TextStyle(color: Color(0xffe6e6ea)),
                            text:
                                '$currentTimeInHour Hr $currentTimeInMin mins'),
                        // TextSpan(text: ' $budgetinLakh Lakhs'),
                      ]),
                )),
            Container(
              color: Colors.green,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                    color: Colors.green,
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: durationPicker()),
                        Expanded(child: durationPicker(inMinutes: true)),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
