// Copyright 2020 Joshua de Guzman (https://joshuadeguzman.github.io). All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

abstract class BaseDialogData {
  const BaseDialogData({
    this.title,
    this.content,
    this.actions,
    this.icon,
  });

  /// The widget shown in the content section.
  final Widget? content;

  /// The widget shown in the title section.
  final Widget? title;

  /// The widgets shown in the actions section.
  final List<Widget>? actions;

  /// The widget shown above the title.
  final Widget? icon;
}
