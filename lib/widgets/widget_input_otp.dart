import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetInputOTP extends StatefulWidget {
  final int length;
  final Size inputSize;
  final TextEditingController controller;

  final Function(String) onSubmitted;
  final Function(String) onChanged;

  final TextStyle? textStyle;

  const WidgetInputOTP({
    Key? key,
    required this.length,
    required this.inputSize,
    required this.onSubmitted,
    required this.onChanged,
    required this.controller,
    this.textStyle,
  }) : super(key: key);

  @override
  _WidgetInputOTPState createState() => _WidgetInputOTPState();
}

class _WidgetInputOTPState extends State<WidgetInputOTP> with SingleTickerProviderStateMixin {
  List<String> _otpCode = [];
  late Animation<double> animation;
  late AnimationController controller;

  // TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
    _otpCode = List.generate(widget.length, (index) => '');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          controller: widget.controller,
          autofocus: true,
          autocorrect: false,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            LengthLimitingTextInputFormatter(widget.length),
            // this limits the input length
          ],
          onChanged: (value) {
            _otpCode = List.generate(widget.length, (index) => '');
            for (int i = 0; i < widget.length; i++) {
              if (value.length == i) break;
              _otpCode[i] = value[i];
            }
            widget.onChanged.call(value);
            setState(() {});
          },
          onFieldSubmitted: widget.onSubmitted,
          // trigger on the complete event handler from the keyboard
          enableInteractiveSelection: false,
          showCursor: false,
          // using same as background color so tha it can blend into the view
          cursorWidth: 0.01,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(0),
            border: InputBorder.none,
            fillColor: Colors.transparent,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
          style: const TextStyle(
            color: Colors.transparent,
            height: .01,
            fontSize: 0.01, // it is a hidden textfield which should remain transparent and extremely small
          ),
        ),
        IgnorePointer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < widget.length; i++)
                widget.controller.text.length == i
                    ? Container(
                        key: ValueKey("OTP: $i"),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: widget.inputSize.height,
                        width: widget.inputSize.width,
                        alignment: Alignment.center,
                        child: AnimatedFocusWidget(animation: animation))
                    : Container(
                        key: ValueKey("OTP: $i"),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: widget.inputSize.height,
                        width: widget.inputSize.width,
                        alignment: Alignment.center,
                        child: Text(
                          _otpCode[i],
                          style: widget.textStyle ?? const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.2),
                        )),
            ],
          ),
        ),
      ],
    );
  }
}

class AnimatedFocusWidget extends AnimatedWidget {
  const AnimatedFocusWidget({super.key, required Animation<double> animation}) : super(listenable: animation);

  // Make the Tweens static because they don't change.
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Opacity(
        opacity: _opacityTween.evaluate(animation),
        child: Container(
          // width: 2,
          // height: 20,
          width: 20,
          height: 2,
          color: Colors.black,
        ),
      ),
    );
  }
}
