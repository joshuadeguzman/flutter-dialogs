// Copyright 2020 Joshua de Guzman (https://joshuadeguzman.github.io). All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'basic_dialog_action.dart';
import 'basic_dialog_alert.dart';
import 'dialog_style.dart';

/// Shows a dialog using [showDialog] on Material platforms and
/// [showCupertinoDialog] on Cupertino platforms.
///
/// The future completes with the value passed to [Navigator.pop] when the
/// dialog closes, or null if it was dismissed.
///
/// [barrierDismissible] controls whether tapping outside the dialog closes it,
/// on every platform. It defaults to false.
Future<T?> showPlatformDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  PlatformDialogStyle style = PlatformDialogStyle.adaptive,
  bool? barrierDismissible,
  @Deprecated('Use barrierDismissible, which works on every platform. '
      'This was deprecated after v3.0.0.')
  bool androidBarrierDismissible = false,
  bool useRootNavigator = true,
  Color? barrierColor,
  String? barrierLabel,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  switch (resolvePlatformDialogStyle(context, style)) {
    case PlatformDialogStyle.cupertino:
      return showCupertinoDialog<T>(
        context: context,
        builder: builder,
        barrierDismissible: barrierDismissible ?? false,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        useRootNavigator: useRootNavigator,
        routeSettings: routeSettings,
        anchorPoint: anchorPoint,
      );
    case _:
      return showDialog<T>(
        context: context,
        builder: builder,
        barrierDismissible: barrierDismissible ?? androidBarrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        useRootNavigator: useRootNavigator,
        routeSettings: routeSettings,
        anchorPoint: anchorPoint,
      );
  }
}

/// Shows a simple alert with a single button and waits for it to close.
///
/// ```dart
/// await showPlatformAlert(
///   context: context,
///   title: 'Location unavailable',
///   message: 'Your location cannot be determined right now.',
/// );
/// ```
Future<void> showPlatformAlert({
  required BuildContext context,
  required String title,
  String? message,
  String okLabel = 'OK',
  Widget? icon,
  PlatformDialogStyle style = PlatformDialogStyle.adaptive,
  bool barrierDismissible = false,
}) {
  return showPlatformDialog<void>(
    context: context,
    style: style,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) => BasicDialogAlert(
      style: style,
      icon: icon,
      title: Text(title),
      content: message == null ? null : Text(message),
      actions: [
        BasicDialogAction(
          style: style,
          isDefaultAction: true,
          title: Text(okLabel),
          onPressed: () => Navigator.of(dialogContext).pop(),
        ),
      ],
    ),
  );
}

/// Asks the user to confirm or cancel, and returns their choice.
///
/// Returns true if the user confirmed. Returns false if they cancelled or
/// dismissed the dialog.
///
/// Set [isDestructive] for actions that delete or discard something. The
/// confirm button is then shown in red.
///
/// ```dart
/// final discard = await showPlatformConfirmation(
///   context: context,
///   title: 'Discard draft?',
///   message: 'This cannot be undone.',
///   confirmLabel: 'Discard',
///   isDestructive: true,
/// );
/// if (discard) deleteDraft();
/// ```
Future<bool> showPlatformConfirmation({
  required BuildContext context,
  required String title,
  String? message,
  String confirmLabel = 'OK',
  String cancelLabel = 'Cancel',
  bool isDestructive = false,
  Widget? icon,
  PlatformDialogStyle style = PlatformDialogStyle.adaptive,
  bool barrierDismissible = false,
}) async {
  final result = await showPlatformDialog<bool>(
    context: context,
    style: style,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) => BasicDialogAlert(
      style: style,
      icon: icon,
      title: Text(title),
      content: message == null ? null : Text(message),
      actions: [
        BasicDialogAction(
          style: style,
          title: Text(cancelLabel),
          onPressed: () => Navigator.of(dialogContext).pop(false),
        ),
        BasicDialogAction(
          style: style,
          isDefaultAction: !isDestructive,
          isDestructiveAction: isDestructive,
          title: Text(confirmLabel),
          onPressed: () => Navigator.of(dialogContext).pop(true),
        ),
      ],
    ),
  );
  return result ?? false;
}
