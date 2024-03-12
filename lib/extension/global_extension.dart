import 'package:flutter/material.dart';

extension GlobalCustom on GlobalKey {
  Size getSize() {
    RenderBox renderBox = currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    return size;
  }

  Offset getOffsetLocalToGlobal() {
    RenderBox renderBox = currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    return offset;
  }

  Offset convertGlobalToLocal(Offset offset) {
    final renderBoxTemp = currentContext!.findRenderObject()! as RenderBox;
    Offset offsetResult = renderBoxTemp.globalToLocal(offset);
    return offsetResult;
  }
}
