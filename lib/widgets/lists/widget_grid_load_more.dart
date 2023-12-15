import 'package:flutter/material.dart';
import 'package:flutter_component/flutter_component.dart';
import 'package:flutter_component/widgets/lists/list_load_more_basic.dart';
import 'package:flutter_component/widgets/loadings/widget_loading_animated.dart';

class WidgetGridLoadMore<T> extends ListLoadMoreBasic<T> {
  const WidgetGridLoadMore(
      {Key? key,
      this.physics,
      this.shrinkWrap = false,
      Function()? onLoadData,
      required this.buildChild,
      this.globalKey,
      this.childrenEnd,
      EdgeInsetsGeometry? padding,
      List<T>? data,
      ScrollController? scrollController,
      Widget Function(BuildContext context)? buildLoading,
      Widget Function(BuildContext context)? buildEmpty,
      bool lastItem = false,
      bool loading = false,
      this.countRow = 2})
      : super(
            key: key,
            lastItem: lastItem,
            buildEmpty: buildEmpty,
            buildLoading: buildLoading,
            data: data,
            onLoadData: onLoadData,
            padding: padding,
            loading: loading,
            scrollController: scrollController);
  final Widget Function(BuildContext context, int index) buildChild;
  final int countRow;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final GlobalKey<NestedScrollViewState>? globalKey;
  final List<Widget>? childrenEnd;

  @override
  State<WidgetGridLoadMore> createState() => _WidgetGridLoadMoreState();
}

class _WidgetGridLoadMoreState<T> extends State<WidgetGridLoadMore> {
  late ScrollController scrollController;
  final double _endReachedThreshold = 400;

  @override
  void initState() {
    scrollController = widget.scrollController ?? ScrollController();
    if (widget.globalKey != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        try {
          // ignore: invalid_use_of_protected_member
          widget.globalKey!.currentState!.innerController.removeListener(_onScrollByGlobalKey);
          widget.globalKey!.currentState!.innerController.addListener(_onScrollByGlobalKey);
        } catch (e) {
          rethrow;
        }
      });
    } else {
      scrollController.addListener(_onScroll);
    }

    super.initState();
  }

  void _onScrollByGlobalKey() async {
    try {
      if (!widget.globalKey!.currentState!.innerController.hasClients || widget.lastItem || widget.loading) {
        return;
      }
      // debugPrint(
      //     "scrollController.position.extentAfter: ${widget.globalKey!.currentState!.innerController.position.extentAfter}");
      final thresholdReached = widget.globalKey!.currentState!.innerController.position.extentAfter < _endReachedThreshold;
      if (thresholdReached) {
        await widget.onLoadData?.call();
      }
    } catch (e) {
      rethrow;
    }
  }

  void _onScroll() async {
    if (!scrollController.hasClients || widget.lastItem || widget.loading) {
      return;
    }
    final thresholdReached = scrollController.position.extentAfter < _endReachedThreshold;
    if (thresholdReached) {
      await widget.onLoadData?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data == null) {
      return widget.buildLoading != null ? widget.buildLoading!.call(context) : widgetLoading(context);
    }
    if (widget.data?.isEmpty == true && widget.lastItem == true) {
      if (widget.physics is! NeverScrollableScrollPhysics) {
        return ListView(
          padding: widget.padding,
          controller: (widget.globalKey != null || widget.physics is NeverScrollableScrollPhysics) ? null : scrollController,
          physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
          shrinkWrap: widget.shrinkWrap,
          children: [widget.buildEmpty?.call(context) ?? const SizedBox()],
        );
      }
      return widget.buildEmpty?.call(context) ?? const SizedBox();
    }
    // if (widget.lastItem == false) {
    //   return widget.buildLoading != null ? widget.buildLoading!.call(context) : widgetLoading(context);
    // }

    final listView = ListComponent.instant.buildBodyWrap<T>(
      context: context,
      countRow: widget.countRow,
      data: (widget.data ?? []) as List<T>,
      lastItem: widget.lastItem,
      buildLoading: widget.buildLoading,
      buildItem: (index) {
        return widget.buildChild.call(context, index);
      },
    );

    return ListView(
      padding: widget.padding,
      controller: (widget.globalKey != null || widget.physics is NeverScrollableScrollPhysics) ? null : scrollController,
      physics: widget.globalKey != null ? const NeverScrollableScrollPhysics() : widget.physics,
      shrinkWrap: widget.shrinkWrap,
      children: [...listView, ...widget.childrenEnd ?? []],
    );
  }

  Widget widgetLoading(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 16),
        child: SizedBox(
          width: 30,
          height: 30,
          child: WidgetLoadingAnimated(),
        ),
      ),
    );
  }

  // // ignore: avoid_shadowing_type_parameters
  // List<Widget> buildBodyWrap<T>(
  //     {required BuildContext context,
  //     required int countRow,
  //     int index = 0,
  //     required List<T>? data,
  //     List<Widget>? listChild,
  //     double vertical = 10,
  //     double horizontal = 10,
  //     required Function(int index) buildItem}) {
  //   listChild ??= [];
  //   List<Widget> listChildRow = [];

  //   if (data != null) {
  //     for (int i = index; i < index + countRow; i++) {
  //       if (i < data.length) {
  //         listChildRow.add(
  //           Expanded(child: buildItem.call(i)),
  //         );
  //         if (i < (index + countRow - 1)) {
  //           listChildRow.add(SizedBox(
  //             width: horizontal,
  //           ));
  //         }
  //       } else {
  //         // listChildRow.add(SizedBox(
  //         //   width: horizontal * (countRow - 1),
  //         // ));
  //         listChildRow.add(const Expanded(child: SizedBox()));
  //       }
  //     }
  //   }

  //   listChild.add(Padding(
  //     padding: EdgeInsets.symmetric(vertical: vertical / 2),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: listChildRow,
  //     ),
  //   ));

  //   if ((index + countRow) < (data?.length ?? 0)) {
  //     buildBodyWrap(index: index + countRow, data: data, listChild: listChild, buildItem: buildItem, context: context, countRow: countRow);
  //   } else {
  //     if (widget.lastItem == false) {
  //       listChild.add(widget.buildLoading?.call(context) ?? const SizedBox());
  //     } else {
  //       listChild.add(const SizedBox());
  //     }
  //   }

  //   return listChild;
  // }
}
