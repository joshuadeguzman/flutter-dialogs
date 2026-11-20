// Copyright 2020 Joshua de Guzman (https://joshuadeguzman.github.io). All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'dialog_style.dart';

/// Builds platform-specific configuration for a dialog.
typedef BaseDialogBuilder<T> = T Function(BuildContext context);

/// A widget that renders a Material widget of type [A] or a Cupertino widget
/// of type [I], depending on [style] and the current platform.
abstract class BaseDialog<A extends Widget, I extends Widget>
    extends StatelessWidget {
  const BaseDialog({super.key, this.style = PlatformDialogStyle.adaptive});

  /// The design language to render with.
  ///
  /// Defaults to [PlatformDialogStyle.adaptive], which follows the platform.
  final PlatformDialogStyle style;

  @override
  Widget build(BuildContext context) {
    return switch (resolvePlatformDialogStyle(context, style)) {
      PlatformDialogStyle.cupertino => buildCupertinoWidget(context),
      _ => buildMaterialWidget(context),
    };
  }

  /// Builds the Material version of this widget.
  A buildMaterialWidget(BuildContext context);

  /// Builds the Cupertino version of this widget.
  I buildCupertinoWidget(BuildContext context);
}
