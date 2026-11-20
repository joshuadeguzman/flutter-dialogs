// Copyright 2020 Joshua de Guzman (https://joshuadeguzman.github.io). All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

abstract class BaseActionData {
  const BaseActionData({
    this.onPressed,
    this.title,
  });

  /// Called when this action is pressed.
  final VoidCallback? onPressed;

  /// The widget shown as the label of this action.
  final Widget? title;
}
