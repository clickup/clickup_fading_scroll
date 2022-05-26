![Logo](doc/banner_dark.svg#gh-dark-mode-only)
![Logo](doc/banner_light.svg#gh-light-mode-only)

<p align="center">Add a fading effect when the user can scroll.</p>

<p align="center"><a href="https://clickup.github.com/fading_scroll">Demo</a></p>

## Quickstart

Add the dependency to `fading_scroll` to your `pubspec.yaml` file.

```bash
flutter pub add clickup_fading_scroll
```

Wrap your scrollable content in a `FadingScroll` widget and give the provided `ScrollController` to your scrollable widget.

```dart
@override
Widget build(BuildContext context) {
    return FadingScroll(
        builder: (context, controller) {
            return ListView(
                controller: controller,
                children: [
                    // ...
                ],
            ),
        },
    );
}
```

## Usage

### Customize fading size and scroll threshold

![Logo](doc/doc_dark.svg#gh-dark-mode-only)
![Logo](doc/doc_light.svg#gh-light-mode-only)

You can customise the effect by providing custom scroll extents and fading sizes.

```dart
@override
Widget build(BuildContext context) {
    return FadingScroll(
        fadingSize: 100,
        scrollExtent: 120,
        builder: (context, controller) {
            return ListView(
                controller: controller,
                children: [
                    // ...
                ],
            ),
        },
    );
}
```

### Using a different controller

You can also provide your own `ScrollController` to the `FadingScroll`. This may be useful for controller subclasses like the `PageController`. 

```dart
class _State_ extends State<Example> {
  late final pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadingScroll(
      controller: pageController,
      builder: (context, controller) {
        return PageView(
          controller: pageController,
          children: [
              // ...
          ],
        );
      },
    );
  }
}
```

## About

This package has been developped by the ClickUp mobile team for it is own needs, but feel free to participate by filing issues or submit pull-requests.

## Open Sourced by ClickUp 💙

![ClickUp](doc/clickup_logo_dark.svg#gh-dark-mode-only)
![ClickUp](doc/clickup_logo_light.svg#gh-light-mode-only)

> Saving people time by making the world more productive.

We're looking for experienced developers.

Be Part of Something Great and [Join Us](https://clickup.com/careers)!