// Copyright 2020 Joshua de Guzman (https://joshuadeguzman.github.io). All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'base_dialog.dart';
import 'base_dialog_data.dart';

/// Platform-specific overrides for a [BasicDialogAlert].
///
/// Any value you leave null falls back to the value set on the
/// [BasicDialogAlert] itself.
class BasicDialogAlertData extends BaseDialogData {
  const BasicDialogAlertData({
    super.title,
    super.content,
    super.actions,
    super.icon,
  });
}

/// An alert dialog that renders as an [AlertDialog] on Material platforms and
/// a [CupertinoAlertDialog] on Cupertino platforms.
class BasicDialogAlert extends BaseDialog<AlertDialog, CupertinoAlertDialog> {
  const BasicDialogAlert({
    super.key,
    super.style,
    this.title,
    this.content,
    this.actions,
    this.icon,
    this.android,
    this.ios,
  });

  /// The widget shown in the title section, usually a [Text].
  final Widget? title;

  /// The widget shown in the content section, usually a [Text].
  final Widget? content;

  /// The actions shown at the bottom, usually [BasicDialogAction]s.
  final List<Widget>? actions;

  /// An optional widget shown above the title, usually an [Icon].
  ///
  /// Material uses [AlertDialog.icon]. Cupertino places it above the title.
  final Widget? icon;

  /// Overrides used only when rendering the Material version.
  final BaseDialogBuilder<BasicDialogAlertData>? android;

  /// Overrides used only when rendering the Cupertino version.
  final BaseDialogBuilder<BasicDialogAlertData>? ios;

  @override
  AlertDialog buildMaterialWidget(BuildContext context) {
    final data = android?.call(context);

    return AlertDialog(
      icon: data?.icon ?? icon,
      title: data?.title ?? title,
      content: data?.content ?? content,
      actions: data?.actions ?? actions,
    );
  }

  @override
  CupertinoAlertDialog buildCupertinoWidget(BuildContext context) {
    final data = ios?.call(context);
    final resolvedIcon = data?.icon ?? icon;
    final resolvedTitle = data?.title ?? title;

    return CupertinoAlertDialog(
      title: resolvedIcon == null
          ? resolvedTitle
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconTheme.merge(
                  data: const IconThemeData(size: 28),
                  child: resolvedIcon,
                ),
                if (resolvedTitle != null) ...[
                  const SizedBox(height: 8),
                  resolvedTitle,
                ],
              ],
            ),
      content: data?.content ?? content,
      actions: data?.actions ?? actions ?? const <Widget>[],
    );
  }
}
