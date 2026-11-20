// Copyright 2020 Joshua de Guzman (https://joshuadeguzman.github.io). All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/// Platform-aware dialogs, alerts and action sheets for Flutter.
///
/// Renders Cupertino widgets on iOS and macOS, and Material widgets
/// everywhere else, from a single API.
library;

export 'src/base_dialog.dart' show BaseDialog, BaseDialogBuilder;
export 'src/basic_dialog_action.dart';
export 'src/basic_dialog_alert.dart';
export 'src/dialog_style.dart';
export 'src/platform_action_sheet.dart';
export 'src/platform_dialog.dart';
