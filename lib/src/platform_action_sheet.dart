// Copyright 2020 Joshua de Guzman (https://joshuadeguzman.github.io). All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dialog_style.dart';

/// One option in a sheet shown by [showPlatformActionSheet].
class PlatformSheetAction<T> {
  const PlatformSheetAction({
    required this.label,
    required this.value,
    this.icon,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
  });

  /// The text shown for this option.
  final String label;

  /// The value returned by [showPlatformActionSheet] when this option is
  /// chosen.
  final T value;

  /// An optional icon. Shown on Material only, since iOS action sheets are
  /// text only.
  final Widget? icon;

  /// Whether this is the preferred option. Shown in bold.
  final bool isDefaultAction;

  /// Whether this option destroys something. Shown in red.
  final bool isDestructiveAction;
}

/// Shows a list of options and returns the [PlatformSheetAction.value] of the
/// one the user picks.
///
/// Cupertino platforms show a [CupertinoActionSheet] with a cancel button
/// labeled [cancelLabel]. Material platforms show a modal bottom sheet with no
/// cancel button, so [cancelLabel] is not used there.
///
/// Returns null if the user cancels or dismisses the sheet.
///
/// ```dart
/// final choice = await showPlatformActionSheet<String>(
///   context: context,
///   title: 'Share photo',
///   actions: const [
///     PlatformSheetAction(label: 'Copy link', value: 'copy', icon: Icon(Icons.link)),
///     PlatformSheetAction(label: 'Delete', value: 'delete', isDestructiveAction: true),
///   ],
/// );
/// ```
Future<T?> showPlatformActionSheet<T>({
  required BuildContext context,
  required List<PlatformSheetAction<T>> actions,
  String? title,
  String? message,
  String cancelLabel = 'Cancel',
  PlatformDialogStyle style = PlatformDialogStyle.adaptive,
  bool useRootNavigator = true,
}) {
  switch (resolvePlatformDialogStyle(context, style)) {
    case PlatformDialogStyle.cupertino:
      return showCupertinoModalPopup<T>(
        context: context,
        useRootNavigator: useRootNavigator,
        builder: (sheetContext) => CupertinoActionSheet(
          title: title == null ? null : Text(title),
          message: message == null ? null : Text(message),
          actions: [
            for (final action in actions)
              CupertinoActionSheetAction(
                isDefaultAction: action.isDefaultAction,
                isDestructiveAction: action.isDestructiveAction,
                onPressed: () => Navigator.of(sheetContext).pop(action.value),
                child: Text(action.label),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(sheetContext).pop(),
            child: Text(cancelLabel),
          ),
        ),
      );
    case _:
      return showModalBottomSheet<T>(
        context: context,
        useRootNavigator: useRootNavigator,
        showDragHandle: true,
        builder: (sheetContext) => _MaterialActionSheet<T>(
          title: title,
          message: message,
          actions: actions,
        ),
      );
  }
}

class _MaterialActionSheet<T> extends StatelessWidget {
  const _MaterialActionSheet({
    required this.actions,
    this.title,
    this.message,
  });

  final String? title;
  final String? message;
  final List<PlatformSheetAction<T>> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasHeader = title != null || message != null;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasHeader)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(title!, style: theme.textTheme.titleMedium),
                    if (message != null) ...[
                      if (title != null) const SizedBox(height: 4),
                      Text(
                        message!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            for (final action in actions)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: action.icon,
                iconColor:
                    action.isDestructiveAction ? colorScheme.error : null,
                textColor:
                    action.isDestructiveAction ? colorScheme.error : null,
                title: Text(
                  action.label,
                  style: action.isDefaultAction
                      ? const TextStyle(fontWeight: FontWeight.w600)
                      : null,
                ),
                onTap: () => Navigator.of(context).pop(action.value),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
