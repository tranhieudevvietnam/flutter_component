import 'package:flutter/material.dart';

extension GlobalCustom on GlobalKey {
  getSize() {
    RenderBox renderBox = currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    return size;
  }

  getOffsetLocalToGlobal() {
    RenderBox renderBox = currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    return offset;
  }

  convertGlobalToLocal(Offset offset) {
    final renderBoxTemp = currentContext!.findRenderObject()! as RenderBox;
    Offset offsetResult = renderBoxTemp.globalToLocal(offset);
    return offsetResult;
  }
}
