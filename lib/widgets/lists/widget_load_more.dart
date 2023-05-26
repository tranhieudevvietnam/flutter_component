import 'package:flutter/material.dart';
import 'package:flutter_component/widgets/lists/list_load_more_basic.dart';
import 'package:flutter_component/widgets/loadings/widget_loading_animated.dart';

class WidgetListLoadMore<T> extends ListLoadMoreBasic<T> {
  const WidgetListLoadMore(
      {Key? key,
      Function()? onLoadData,
      required this.buildChild,
      EdgeInsetsGeometry? padding,
      List<T>? data,
      ScrollController? scrollController,
      Widget Function(BuildContext context)? buildLoading,
      Widget Function(BuildContext context)? buildEmpty,
      bool lastItem = false})
      : super(
            lastItem: lastItem,
            buildEmpty: buildEmpty,
            buildLoading: buildLoading,
            data: data,
            onLoadData: onLoadData,
            padding: padding,
            scrollController: scrollController);
  final Widget Function(BuildContext context, int index) buildChild;

  @override
  State<WidgetListLoadMore> createState() => _WidgetListLoadMoreState();
}

class _WidgetListLoadMoreState extends State<WidgetListLoadMore> {
  late ScrollController scrollController;
  final double _endReachedThreshold = 200;
  final bool _loading = false;

  @override
  void initState() {
    scrollController = widget.scrollController ?? ScrollController();
    scrollController.addListener(_onScroll);

    super.initState();
  }

  void _onScroll() {
    if (!scrollController.hasClients || _loading) {
      return;
    }
    final thresholdReached =
        scrollController.position.extentAfter < _endReachedThreshold;
    if (thresholdReached) {
      widget.onLoadData?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final length = widget.data?.length ?? 0;
    return ListView.builder(
      padding: widget.padding,
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: length,
      itemBuilder: (context, index) {
        if (index == length) {
          if (widget.data == null) {
            return widgetLoading(context);
          }
          if (length == 0) {
            return widget.buildEmpty?.call(context) ?? const SizedBox();
          }
          if (widget.lastItem == false && length > 0) {
            return widgetLoading(context);
          }
          return const SizedBox();
        }
        return widget.buildChild.call(context, index);
      },
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
}
