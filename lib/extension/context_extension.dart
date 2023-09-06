import 'package:flutter/material.dart';

extension ContextCustom on BuildContext {
  Size screenSize() {
    return MediaQuery.of(this).size;
  }

  Size getRenderSize() {
    final RenderBox renderBox = findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    // print('Size: ${size.width}, ${size.height}');
    // final Offset offset = renderBox.localToGlobal(Offset.zero);
    // print('Offset: ${offset.dx}, ${offset.dy}');
    // print('Position: ${(offset.dx + size.width) / 2}, ${(offset.dy + size.height) / 2}');

    return size;
  }

  Offset getRenderOffset() {
    final RenderBox renderBox = findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    // print('Offset: ${offset.dx}, ${offset.dy}');
    return offset;
  }
}
