## [4.0.0] - November 20, 2026
- Support Dart 3 and current Flutter. The SDK constraint was `<3.0.0`, which blocked every Flutter release since 3.10.
- Add `showPlatformAlert` and `showPlatformConfirmation`, which close themselves and return the result.
- Add `showPlatformActionSheet` and `PlatformSheetAction`: a `CupertinoActionSheet` on iOS and macOS, and a modal bottom sheet everywhere else.
- Add `PlatformDialogStyle` and a `style` parameter on every API, to follow the platform or force Material or Cupertino. `resolvePlatformDialogStyle` returns the style that will be used.
- Add `icon` to `BasicDialogAlert` and `BasicDialogAlertData`.
- Add `isDefaultAction` and `isDestructiveAction` to `BasicDialogAction`, which now style Material too.
- Add `barrierDismissible`, `barrierColor`, `barrierLabel`, `routeSettings` and `anchorPoint` to `showPlatformDialog`. `barrierDismissible` works on every platform.
- Make widgets `const` and accept a `key`.
- Export `BaseDialog` so you can build your own platform-aware widgets.
- Deprecate `androidBarrierDismissible`, `iosIsDefaultAction` and `iosIsDestructiveAction`. They still work.
- **Behavior change:** an `android` or `ios` override without `actions` now falls back to the shared `actions` instead of showing none. Pass `actions: const []` to hide them.
- Add widget tests for iOS and Android.
- Rebuild the example app as a demo gallery and refresh the screenshots.

## [3.0.0] - July 22, 2022
- Add support for the web and other platforms
- Fix references to the design language of the native platforms

## [2.2.0] - July 18, 2022
- Update Flutter and Dark SDK
- Fix deprecated examples and Gradle issues

## [2.1.1] - October 12, 2021
- Update README with explicit `context` parameter for demos

## [2.1.0] - June 20, 2021
- Added iosIsDestructiveAction and iosIsDefaultAction params. Thank you @Bersh
- Allowing null actions for Android AlertDialog. Thank you @Bersh

## [2.0.0] - June 17, 2021
- Migrate to null safety #8. Thank you @Bersh

## [1.1.0] - October 20, 2020

- Migrate example app to latest stable SDK
- Update dependencies
- Set min Dart SDK to 2.7.0
- Added code docs

## [1.0.4] - May 26, 2020

- Fix issue [#2](https://github.com/joshuadeguzman/flutter_dialogs/issues/2)

## [1.0.3] - March 28, 2020

- Documentation fixes

## [1.0.2] - January 21, 2020

- Update some formatting
- Update description in pubspec.yaml

## [1.0.1] - January 21, 2020

- Fix broken table in README

## [1.0.0] - January 21, 2020

- Major code refactoring

## [0.0.1+2] - October 5, 2019

- Documentation fixes

## [0.0.1+1] - October 5, 2019

- Initial attempt to make platform aware dialog and alert widgets
- Added `FDBasicDialog` and other core utilities
