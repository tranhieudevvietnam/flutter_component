import 'package:flutter/material.dart';

typedef BuildWidgetDropdown<T> = Widget Function(BuildContext context, T? data);

// class DropdownItem {
//   final String title;
//   final dynamic value;

//   DropdownItem({required this.title, required this.value});
// }

// ignore: must_be_immutable
class WidgetDropdown<T> extends StatefulWidget {
  final BuildWidgetDropdown<T> builderDropdownItem;
  final BuildWidgetDropdown<T> builderDropdownItemMenu;
  final List<T> listData;
  final Function(T value)? onChange;
  final Function(OverlayEntry overlayEntry)? initOverlayEntry;
  T? data;
  WidgetDropdown({
    super.key,
    required this.listData,
    required this.builderDropdownItem,
    required this.builderDropdownItemMenu,
    this.data,
    this.initOverlayEntry,
    this.onChange,
  });

  @override
  // ignore: library_private_types_in_public_api
  _WidgetDropdownState<T> createState() => _WidgetDropdownState<T>();
}

class _WidgetDropdownState<T> extends State<WidgetDropdown<T>> {
  // final FocusNode _focusNode = FocusNode();

  late OverlayEntry _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  bool showDropView = false;

  @override
  void initState() {
    super.initState();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
        builder: (context) => Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                child: Material(
                  elevation: 4.0,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: List.generate(
                        widget.listData.length,
                        (index) => GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _onTap.call(
                                    itemSelected: widget.listData[index]);
                              },
                              child: widget.builderDropdownItemMenu
                                  .call(context, widget.listData[index]),
                            )),
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
          onTap: _onTap,
          behavior: HitTestBehavior.translucent,
          child: widget.builderDropdownItem.call(context, widget.data)),
    );
  }

  void _onTap({T? itemSelected}) {
    FocusScope.of(context).requestFocus(FocusNode());

    if (itemSelected != null) {
      setState(() {
        widget.data = itemSelected;
      });
      widget.onChange?.call(itemSelected);
    }

    try {
      if (showDropView == false) {
        _overlayEntry = _createOverlayEntry();

        _overlayEntry.addListener(() {
          showDropView = !showDropView;
        });
        widget.initOverlayEntry?.call(_overlayEntry);
        Overlay.of(context).insert(_overlayEntry);
      } else {
        _overlayEntry.remove();
      }
    } catch (error) {
      rethrow;
    }
  }
}
