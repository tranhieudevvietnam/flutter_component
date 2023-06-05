import 'package:flutter/material.dart';

abstract class ListLoadMoreBasic<T> extends StatefulWidget {
  final List<T>? data;
  final Function()? onLoadData;
  final Widget Function(BuildContext context)? buildLoading;
  final Widget Function(BuildContext context)? buildEmpty;
  final ScrollController? scrollController;
  final bool lastItem;
  final bool loading;
  final EdgeInsetsGeometry? padding;

  const ListLoadMoreBasic(
      {Key? key,
      this.data,
      this.onLoadData,
      this.buildLoading,
      this.buildEmpty,
      this.padding,
      this.scrollController,
      required this.lastItem,
      required this.loading})
      : super(key: key);
}
