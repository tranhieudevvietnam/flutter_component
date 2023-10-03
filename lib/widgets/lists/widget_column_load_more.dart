import 'package:flutter/material.dart';
import 'package:flutter_component/widgets/lists/list_load_more_basic.dart';
import 'package:flutter_component/widgets/loadings/widget_loading_animated.dart';

class WidgetColumnListLoadMore<T> extends ListLoadMoreBasic<T> {
  const WidgetColumnListLoadMore({
    Key? key,
    Function()? onLoadData,
    required this.buildChild,
    this.globalKey,
    this.mainAxisSize,
    this.childrenEnd,
    EdgeInsetsGeometry? padding,
    List<T>? data,
    ScrollController? scrollController,
    Widget Function(BuildContext context)? buildLoading,
    Widget Function(BuildContext context)? buildEmpty,
    bool loading = false,
    bool lastItem = false,
  }) : super(
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
  final GlobalKey<NestedScrollViewState>? globalKey;
  final MainAxisSize? mainAxisSize;
  final Widget? childrenEnd;

  @override
  State<WidgetColumnListLoadMore> createState() => _WidgetColumnListLoadMoreState();
}

class _WidgetColumnListLoadMoreState extends State<WidgetColumnListLoadMore> {
  late ScrollController scrollController;
  final double _endReachedThreshold = 200;

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
      final thresholdReached = widget.globalKey!.currentState!.innerController.position.extentAfter < _endReachedThreshold;
      if (thresholdReached) {
        await widget.onLoadData?.call();
      }
    } catch (e) {
      rethrow;
    }
  }

  void _onScroll() {
    if (!scrollController.hasClients || widget.loading || widget.lastItem) {
      return;
    }
    final thresholdReached = scrollController.position.extentAfter < _endReachedThreshold;
    if (thresholdReached) {
      widget.onLoadData?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final length = (widget.data?.length ?? 0) + 1;

    return Column(
      mainAxisSize: widget.mainAxisSize ?? MainAxisSize.max,
      children: List.generate(length, (index) {
        if (index == length - 1) {
          if (widget.data == null) {
            return widgetLoading(context);
          }
          if (widget.data?.isEmpty == true && widget.lastItem == true) {
            return widget.buildEmpty?.call(context) ?? const SizedBox();
          }
          if (widget.lastItem == false) {
            return widgetLoading(context);
          }

          return widget.childrenEnd ?? const SizedBox();
        }
        return widget.buildChild.call(context, index);
      }),
    );
    // return SingleChildScrollView(
    //   padding: widget.padding,
    //   controller: widget.globalKey != null ? null : scrollController,
    //   child: Column(
    //     mainAxisSize: widget.mainAxisSize ?? MainAxisSize.max,
    //     children: List.generate(length, (index) {
    //       if (index == length - 1) {
    //         if (widget.data == null) {
    //           return widgetLoading(context);
    //         }
    //         if (widget.data?.isEmpty == true && widget.lastItem == true) {
    //           return widget.buildEmpty?.call(context) ?? const SizedBox();
    //         }
    //         if (widget.lastItem == false) {
    //           return widgetLoading(context);
    //         }

    //         return const SizedBox();
    //       }
    //       return widget.buildChild.call(context, index);
    //     }),
    //   ),
    // );
  }

  Widget widgetLoading(BuildContext context) {
    if (widget.buildLoading == null) {
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
    return widget.buildLoading!.call(context);
  }
}
