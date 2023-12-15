import 'package:flutter/material.dart';

class ListComponent {
  ListComponent._();
  static ListComponent instant = ListComponent._();

  // ignore: avoid_shadowing_type_parameters
  List<Widget> buildBodyWrap<T>(
      {required BuildContext context,
      required int countRow,
      bool lastItem = true,
      int index = 0,
      required List<T>? data,
      List<Widget>? listChild,
      double vertical = 10,
      double horizontal = 10,
      Function(BuildContext context)? buildLoading,
      required Function(int index) buildItem}) {
    listChild ??= [];
    List<Widget> listChildRow = [];

    if (data != null) {
      for (int i = index; i < index + countRow; i++) {
        if (i < data.length) {
          listChildRow.add(
            Expanded(child: buildItem.call(i)),
          );
          if (i < (index + countRow - 1)) {
            listChildRow.add(SizedBox(
              width: horizontal,
            ));
          }
        } else {
          // listChildRow.add(SizedBox(
          //   width: horizontal * (countRow - 1),
          // ));
          listChildRow.add(const Expanded(child: SizedBox()));
        }
      }
    }

    listChild.add(Padding(
      padding: EdgeInsets.symmetric(vertical: vertical / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: listChildRow,
      ),
    ));

    if ((index + countRow) < (data?.length ?? 0)) {
      buildBodyWrap(
          index: index + countRow, data: data, listChild: listChild, buildItem: buildItem, context: context, countRow: countRow, lastItem: lastItem);
    } else {
      if (lastItem == false) {
        listChild.add(buildLoading?.call(context) ?? const SizedBox());
      } else {
        listChild.add(const SizedBox());
      }
    }

    return listChild;
  }
}
