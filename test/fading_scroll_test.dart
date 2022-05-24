import 'package:fading_scroll/fading_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void setup(WidgetTester tester) {
  tester.binding.window.physicalSizeTestValue = const Size(500, 400);
  tester.binding.window.devicePixelRatioTestValue = 1;
}

void tearDown(WidgetTester tester) {
  addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);
}

void main() {
  testWidgets('Not scrollable content', (WidgetTester tester) async {
    setup(tester);

    await tester.pumpWidget(
      Content(
        scrollExtent: 0,
        totalExtent: tester.binding.window.physicalSize.height,
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(Content),
      matchesGoldenFile(
        'not_scrollable.png',
      ),
    );

    tearDown(tester);
  });

  testWidgets('Scrollable content', (WidgetTester tester) async {
    setup(tester);
    const totalExtent = 5000.0;
    await tester.pumpWidget(
      const Content(
        scrollExtent: 0,
        totalExtent: totalExtent,
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(Content),
      matchesGoldenFile(
        'vertical_not_scrolled.png',
      ),
    );

    await tester.pumpWidget(
      const Content(
        scrollExtent: 25,
        totalExtent: totalExtent,
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(Content),
      matchesGoldenFile(
        'vertical_start_scrolling.png',
      ),
    );

    await tester.pumpWidget(
      const Content(
        scrollExtent: 1250,
        totalExtent: totalExtent,
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(Content),
      matchesGoldenFile(
        'vertical_scrolling.png',
      ),
    );

    await tester.pumpWidget(
      Content(
        scrollExtent:
            totalExtent - tester.binding.window.physicalSize.height - 25,
        totalExtent: totalExtent,
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(Content),
      matchesGoldenFile(
        'vertical_near_end.png',
      ),
    );

    await tester.pumpWidget(
      Content(
        scrollExtent: totalExtent - tester.binding.window.physicalSize.height,
        totalExtent: totalExtent,
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(Content),
      matchesGoldenFile(
        'vertical_near_end.png',
      ),
    );

    tearDown(tester);
  });
}

class Content extends StatefulWidget {
  const Content({
    Key? key,
    required this.scrollExtent,
    this.totalExtent,
    this.scrollDirection = Axis.vertical,
  }) : super(key: key);

  final double scrollExtent;
  final double? totalExtent;
  final Axis scrollDirection;

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final ScrollController controller = ScrollController();

  @override
  void didUpdateWidget(covariant Content oldWidget) {
    if (oldWidget.scrollExtent != widget.scrollExtent) {
      controller.animateTo(
        widget.scrollExtent,
        duration: const Duration(milliseconds: 1),
        curve: Curves.linear,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: Colors.white,
        child: FadingScroll(
          controller: controller,
          builder: (context, controller) {
            return SingleChildScrollView(
              controller: controller,
              scrollDirection: widget.scrollDirection,
              child: Container(
                width: widget.scrollDirection == Axis.horizontal
                    ? widget.totalExtent
                    : null,
                height: widget.scrollDirection == Axis.vertical
                    ? widget.totalExtent
                    : null,
                color: Colors.red,
              ),
            );
          },
        ),
      ),
    );
  }
}
