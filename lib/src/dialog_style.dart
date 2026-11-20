// Copyright 2020 Joshua de Guzman (https://joshuadeguzman.github.io). All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The design language used to render a dialog, action or sheet.
enum PlatformDialogStyle {
  /// Picks the style from the current platform.
  ///
  /// iOS and macOS use [cupertino]. Android, Fuchsia, Linux, Windows and the
  /// web use [material]. The platform is read from [ThemeData.platform], so it
  /// respects any platform override set on your app's theme.
  adaptive,

  /// Always uses Material widgets, such as [AlertDialog].
  material,

  /// Always uses Cupertino widgets, such as `CupertinoAlertDialog`.
  cupertino,
}

/// Resolves [style] into either [PlatformDialogStyle.material] or
/// [PlatformDialogStyle.cupertino] for the given [context].
///
/// Never returns [PlatformDialogStyle.adaptive].
PlatformDialogStyle resolvePlatformDialogStyle(
  BuildContext context, [
  PlatformDialogStyle style = PlatformDialogStyle.adaptive,
]) {
  if (style != PlatformDialogStyle.adaptive) return style;
  if (kIsWeb) return PlatformDialogStyle.material;

  return switch (Theme.of(context).platform) {
    TargetPlatform.iOS || TargetPlatform.macOS => PlatformDialogStyle.cupertino,
    TargetPlatform.android ||
    TargetPlatform.fuchsia ||
    TargetPlatform.linux ||
    TargetPlatform.windows =>
      PlatformDialogStyle.material,
  };
}
