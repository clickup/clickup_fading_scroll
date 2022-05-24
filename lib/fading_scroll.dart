library fading_scroll;

import 'package:flutter/material.dart';

/// A widget builder for a scrollable subtree that must fade with a
/// [FadingScrollable].
typedef FadingScrollWidgetBuilder = Widget Function(
  BuildContext context,
  ScrollController controller,
);

/// Add a fading effect to a scrollable [child].
class FadingScroll extends StatefulWidget {
  const FadingScroll({
    Key? key,
    required this.builder,
    this.controller,
    double? startFadingSize,
    double? endFadingSize,
    double? fadingSize,
    double? startScrollExtent,
    double? endScrollExtent,
    double? scrollExtent,
  })  : startScrollExtent = startScrollExtent ?? scrollExtent,
        endScrollExtent = endScrollExtent ?? scrollExtent,
        startFadingSize = startFadingSize ?? fadingSize,
        endFadingSize = endFadingSize ?? fadingSize,
        super(key: key);

  /// The scroll controller that is used to track the scrolling status.
  ///
  /// If not provided, one is created internally and given to the [builder].
  final ScrollController? controller;

  /// A builder for the scrollable child that will have the fading mask applied.
  final FadingScrollWidgetBuilder builder;

  /// The minimum amount of scroll needed after which the fading mask has
  /// its [startFadingSize] full size.
  final double? startScrollExtent;

  /// The minimum amount of scroll needed before which the fading mask has
  /// its [endFadingSize] full size.
  ///
  /// If not provided, it is equivalent to [endScrollExtent]. And if neither
  /// [startScrollExtent] nor [endScrollExtent] is provided then its value
  /// is [defaultScrollExtent].
  final double? endScrollExtent;

  /// The fading mask maximum size when there is content hidden before the
  /// start of the current scroll position.
  ///
  /// If not provided, it is equivalent to [startScrollExtent]. And if neither
  /// [startScrollExtent] nor [endScrollExtent] is provided then its value
  /// is [defaultScrollExtent].
  final double? startFadingSize;

  /// The fading mask maximum size when there is content hidden after the
  /// end of the current scroll position.
  ///
  /// If not provided, it is equivalent to [endScrollExtent].
  final double? endFadingSize;

  /// The default value if neither [startScrollExtent] nor [endScrollExtent] is
  /// provided to a [FadingScroll].
  static const defaultScrollExtent = 50.0;

  @override
  State<FadingScroll> createState() => _FadingScrollableState();
}

class _FadingScrollableState extends State<FadingScroll> {
  late ScrollController controller = widget.controller ?? ScrollController();

  @override
  void didUpdateWidget(covariant FadingScroll oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newController = widget.controller;
    if (oldWidget.controller == null && newController != null) {
      controller.dispose();
      setState(() {
        controller = newController;
      });
    } else if (oldWidget.controller != null && newController == null) {
      setState(() {
        controller = ScrollController();
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  double _fadingMaxAmount(double maxExtent) {
    final viewportDimension =
        controller.hasClients ? controller.position.viewportDimension : 0.0;
    return (maxExtent / viewportDimension).clamp(0, 0.5);
  }

  @override
  Widget build(BuildContext context) {
    final startScrollExtent = widget.startScrollExtent ??
        widget.endScrollExtent ??
        FadingScroll.defaultScrollExtent;
    final endScrollExtent = widget.endScrollExtent ??
        widget.startScrollExtent ??
        FadingScroll.defaultScrollExtent;

    final startFadingMaxExtent = widget.startFadingSize ?? startScrollExtent;
    final endFadingMaxExtent = widget.endFadingSize ?? endScrollExtent;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final isAttached = controller.hasClients;
        final isVertical =
            !isAttached || controller.position.axis == Axis.vertical;
        final startAmount = !isAttached
            ? 0.0
            : (controller.position.extentBefore / startScrollExtent)
                .clamp(0.0, 1.0);
        final endAmount = !isAttached
            ? 0.0
            : (controller.position.extentAfter / endScrollExtent)
                .clamp(0.0, 1.0);
        final startFadingMaxAmount = _fadingMaxAmount(startFadingMaxExtent);
        final endFadingMaxAmount = _fadingMaxAmount(endFadingMaxExtent);
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: isVertical ? Alignment.topCenter : Alignment.centerLeft,
              end: isVertical ? Alignment.bottomCenter : Alignment.centerRight,
              colors: <Color>[
                if (startAmount > 0.0) const Color(0x00FFFFFF),
                const Color(0xFFFFFFFF),
                const Color(0xFFFFFFFF),
                if (endAmount > 0.0) const Color(0x00FFFFFF),
              ],
              stops: <double>[
                0.0,
                if (startAmount > 0.0) startFadingMaxAmount * startAmount,
                if (endAmount > 0.0) 1 - endFadingMaxAmount * endAmount,
                1,
              ],
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.builder(context, controller),
    );
  }
}
