import 'package:flutter/material.dart';

class WidgetKeepAlive extends StatefulWidget {
  final Widget child;

  const WidgetKeepAlive({Key? key, required this.child});

  @override
  State<StatefulWidget> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<WidgetKeepAlive> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

Widget keepAliveWrapper(Widget child) => WidgetKeepAlive(child: child);
