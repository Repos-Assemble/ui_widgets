// Copyright (c) 2025 Order of Runes Authors. All rights reserved.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:common_utils/utils.dart';

// TODO (Ishwor) Dig into the issue where the scroll position is reset
class BetterListView extends StatefulWidget {
  BetterListView({
    super.key,
    required List<Widget> children,
    this.onRefresh,
    this.padding = EdgeInsets.zero,
    this.header,
    this.bottom,
    this.loadMore = false,
    this.pinHeader = false,
    this.onLoadMore,
    this.controller,
  }) : _delegate = SliverChildListDelegate(children);

  BetterListView.builder({
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    this.onRefresh,
    this.padding = EdgeInsets.zero,
    this.header,
    this.bottom,
    this.loadMore = false,
    this.pinHeader = false,
    this.onLoadMore,
    this.controller,
  }) : _delegate = SliverChildBuilderDelegate(itemBuilder, childCount: itemCount);

  BetterListView.separated({
    required IndexedWidgetBuilder itemBuilder,
    required IndexedWidgetBuilder separatorBuilder,
    required int itemCount,
    this.onRefresh,
    this.padding = EdgeInsets.zero,
    this.header,
    this.bottom,
    this.loadMore = false,
    this.pinHeader = false,
    this.onLoadMore,
    this.controller,
  }) : _delegate = SliverChildBuilderDelegate((context, index) {
         final int itemIndex = index ~/ 2;
         if (index.isEven) {
           return itemBuilder(context, itemIndex);
         }
         return separatorBuilder(context, itemIndex);
       }, childCount: _computeActualChildCount(itemCount));

  final EdgeInsets padding;
  final RefreshCallback? onRefresh;
  final ScrollController? controller;

  final PreferredSizeWidget? header;
  final Widget? bottom;

  final bool loadMore;
  final bool pinHeader;
  final Future<void> Function()? onLoadMore;

  final SliverChildDelegate _delegate;

  @override
  State<BetterListView> createState() => _BetterListViewState();

  // Helper method to compute the actual child count for the separated constructor.
  static int _computeActualChildCount(int itemCount) {
    return math.max(0, itemCount * 2 - 1);
  }
}

class _BetterListViewState extends State<BetterListView> {
  bool isLoadingMore = false;

  @override
  Widget build(BuildContext context) {
    final Widget listWidget = CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: widget.controller,
      slivers: [
        if (widget.header.isNotNull) SliverPersistentHeader(delegate: _HeaderDelegate(widget.header!), pinned: widget.pinHeader),
        SliverPadding(
          padding: widget.padding,
          sliver: SliverList(delegate: widget._delegate),
        ),
        if (widget.onLoadMore.isNotNull && widget.loadMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 40,
              ),
              child: SizedBox(
                height: 8,
                width: 200,
                child: LinearProgressIndicator(borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ),
        if (widget.bottom.isNotNull)
          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: true,
            child: Align(alignment: Alignment.bottomCenter, child: widget.bottom),
          ),
      ],
    );

    final Widget child;
    if (widget.loadMore && widget.onLoadMore.isNotNull) {
      child = NotificationListener<ScrollEndNotification>(
        onNotification: (scrollNotification) {
          final scrollMetrics = scrollNotification.metrics;
          final hasReachedEnd = scrollMetrics.pixels >= 0.8 * scrollMetrics.maxScrollExtent;
          if (hasReachedEnd) _notifyLoadMore();
          return false;
        },
        child: listWidget,
      );
    } else {
      child = listWidget;
    }

    if (widget.onRefresh.isNull) return child;

    return RefreshIndicator(onRefresh: widget.onRefresh!, child: child);
  }

  Future<void> _notifyLoadMore() async {
    if (!isLoadingMore) {
      isLoadingMore = true;
      await widget.onLoadMore!();
      isLoadingMore = false;
    }
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  const _HeaderDelegate(this.header);

  final PreferredSizeWidget header;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(child: header);
  }

  @override
  bool shouldRebuild(_HeaderDelegate oldDelegate) => oldDelegate.header.hashCode != header.hashCode;

  double get _height => header.preferredSize.height;
}
