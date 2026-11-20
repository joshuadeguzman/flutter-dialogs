// Copyright 2020 Joshua de Guzman (https://joshuadeguzman.github.io). All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'base_action_data.dart';
import 'base_dialog.dart';

class BasicDialogActionData extends BaseActionData {
  const BasicDialogActionData({
    super.onPressed,
    super.title,
  });
}

/// A dialog action that renders as a [TextButton] on Material platforms and a
/// [CupertinoDialogAction] on Cupertino platforms.
class BasicDialogAction extends BaseDialog<TextButton, CupertinoDialogAction> {
  const BasicDialogAction({
    super.key,
    super.style,
    this.onPressed,
    this.title,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    @Deprecated('Use isDestructiveAction, which also styles Material. '
        'This was deprecated after v3.0.0.')
    this.iosIsDestructiveAction = false,
    @Deprecated('Use isDefaultAction, which also styles Material. '
        'This was deprecated after v3.0.0.')
    this.iosIsDefaultAction = false,
  });

  /// Called when this action is pressed.
  ///
  /// If null, the action is disabled.
  final VoidCallback? onPressed;

  /// The label of this action, usually a [Text] widget.
  final Widget? title;

  /// Whether this is the preferred action in the dialog.
  ///
  /// Cupertino renders it in bold, like
  /// [UIAlertController.preferredAction](https://developer.apple.com/documentation/uikit/uialertcontroller/1620102-preferredaction).
  /// Material renders its label in bold.
  final bool isDefaultAction;

  /// Whether this action destroys something, such as deleting an email.
  ///
  /// Cupertino renders it in red. Material renders it with
  /// [ColorScheme.error].
  final bool isDestructiveAction;

  /// Whether this action destroys something. Only used on Cupertino.
  @Deprecated('Use isDestructiveAction, which also styles Material. '
      'This was deprecated after v3.0.0.')
  final bool iosIsDestructiveAction;

  /// Whether this is the preferred action. Only used on Cupertino.
  @Deprecated('Use isDefaultAction, which also styles Material. '
      'This was deprecated after v3.0.0.')
  final bool iosIsDefaultAction;

  @override
  TextButton buildMaterialWidget(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: onPressed,
      style: isDestructiveAction
          ? TextButton.styleFrom(foregroundColor: colorScheme.error)
          : null,
      child: _label(
        isDefaultAction ? const TextStyle(fontWeight: FontWeight.w600) : null,
      ),
    );
  }

  @override
  CupertinoDialogAction buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      onPressed: onPressed,
      // ignore: deprecated_member_use_from_same_package
      isDestructiveAction: isDestructiveAction || iosIsDestructiveAction,
      // ignore: deprecated_member_use_from_same_package
      isDefaultAction: isDefaultAction || iosIsDefaultAction,
      child: title ?? const SizedBox.shrink(),
    );
  }

  Widget _label(TextStyle? style) {
    final child = title ?? const SizedBox.shrink();
    if (style == null) return child;
    return DefaultTextStyle.merge(style: style, child: child);
  }
}
