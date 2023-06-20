import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DataStream {
  final Offset? offset;
  final Size? sizeDialog;

  DataStream({this.offset, this.sizeDialog});
}

abstract class IDialogAnimation {
  // double positionTop = 0.0;
  Size? sizeChild;

  StreamController<DataStream?> streamController =
      StreamController<DataStream?>();
  GlobalKey globalKeyDialog = GlobalKey();
  int? index;

  // ValueNotifier<Offset?> position = ValueNotifier(null);
  // ValueNotifier<Offset?> position2 = ValueNotifier(null);

  hide() {
    index = null;
    sizeChild = null;
    streamController.sink.add(null);
  }

  Widget buildItem({
    required BuildContext context,
    required int index,
    required Widget Function(
      BuildContext context,
      GlobalKey globalKey,
    )
        child,
  }) {
    GlobalKey globalKey = GlobalKey();
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onLongPress: () async {
          await HapticFeedback.mediumImpact();
          final RenderBox renderBoxWidget =
              globalKey.currentContext?.findRenderObject() as RenderBox;
          sizeChild = renderBoxWidget.size;
          this.index = index;

          streamController.sink.add(DataStream(
              offset: renderBoxWidget.localToGlobal(Offset.zero),
              sizeDialog: getSizeDialog(globalKeyDialog)));

          // print('Size: ${size.width}, ${size.height}');
          // if (onPositionLeftOrRight.call()) {
          //   position2.value = renderBoxWidget.localToGlobal(Offset.zero);
          // } else {
          //   position1.value = renderBoxWidget.localToGlobal(Offset.zero);
          // }
        },
        child: child.call(
          context,
          globalKey,
        ));
  }

  Size? getSizeDialog(GlobalKey globalKey) {
    try {
      final RenderBox renderBoxWidget =
          globalKey.currentContext?.findRenderObject() as RenderBox;

      final size = renderBoxWidget.size;
      return size;
    } catch (e) {
      return null;
    }
  }

  Widget buildBodyDialogAnimation({
    required BuildContext context,
    required Widget child,
    required Widget Function(
            BuildContext context, GlobalKey? globalKey, int index)
        childDialog,
  }) {
    final widgetDialog = childDialog.call(context, globalKeyDialog, index ?? 0);
    final ktTop = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        Opacity(
          opacity: 0.0,
          child: widgetDialog,
        ),
        child,
        StreamBuilder<DataStream?>(
          stream: streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData == true) {
              double dy = snapshot.data!.offset!.dy -
                  (snapshot.data!.sizeDialog?.height ?? 0);
              if (dy < (kToolbarHeight + ktTop)) {
                dy = snapshot.data!.offset!.dy + (sizeChild?.height ?? 0);
              }
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      hide();
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                  Positioned(
                    left: snapshot.data!.offset!.dx,
                    // top: 105,
                    top: dy,
                    child: CustomScaleTransition(
                      child: (context) =>
                          childDialog.call(context, null, index ?? 0),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        )

        // AnimatedPositioned(
        //   duration: const Duration(milliseconds: 500),
        //   curve: Curves.easeInOut,
        //   top: position1.value?.dy ?? (positionTop),
        //   left: position1.value != null
        //       ? 10.0
        //       : -MediaQuery.of(context).size.width,
        //   right: 10,
        //   child: position1.value != null
        //       ? CustomScaleTransition(
        //           child: childDialogLeft,
        //         )
        //       : const SizedBox(),
        // ),
        // AnimatedPositioned(
        //   duration: const Duration(milliseconds: 500),
        //   curve: Curves.easeInOut,
        //   top: position2.value?.dy ?? (positionTop),
        //   left: position2.value != null
        //       ? 10.0
        //       : MediaQuery.of(context).size.width,
        //   right: 10,
        //   child: position2.value != null
        //       ? CustomScaleTransition(
        //           child: childDialogRight,
        //         )
        //       : const SizedBox(),
        // ),
      ],
    );
  }
}

class CustomScaleTransition extends StatefulWidget {
  const CustomScaleTransition({super.key, required this.child});
  // final Size size;
  final Widget Function(BuildContext context) child;

  @override
  State<CustomScaleTransition> createState() => _CustomScaleTransitionState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _CustomScaleTransitionState extends State<CustomScaleTransition>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );
  @override
  void initState() {
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child.call(context),
      // child: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     Container(
      //       width: 200,
      //       height: 100,
      //       decoration: BoxDecoration(
      //         color: Colors.white,
      //         borderRadius: BorderRadius.circular(12),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
