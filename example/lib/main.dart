import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

/// Opens a demo right after launch, for example
/// `flutter run --dart-define=DEMO=confirmation`.
///
/// Used to capture the screenshots in the README.
const _autoOpenDemo = String.fromEnvironment('DEMO');

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_dialogs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const DemoGallery(),
    );
  }
}

class Demo {
  const Demo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.run,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Future<String?> Function(
      BuildContext context, PlatformDialogStyle style) run;
}

final demos = <Demo>[
  Demo(
    id: 'alert',
    title: 'Alert',
    subtitle: 'showPlatformAlert',
    icon: Icons.info_outline,
    run: (context, style) async {
      await showPlatformAlert(
        context: context,
        style: style,
        title: 'Location unavailable',
        message: 'Your current location cannot be determined right now.',
      );
      return 'Alert closed';
    },
  ),
  Demo(
    id: 'icon',
    title: 'Alert with icon',
    subtitle: 'icon on BasicDialogAlert',
    icon: Icons.wifi_off,
    run: (context, style) async {
      await showPlatformAlert(
        context: context,
        style: style,
        icon: const Icon(Icons.wifi_off),
        title: "You're offline",
        message: 'Changes will sync when you reconnect.',
      );
      return 'Alert closed';
    },
  ),
  Demo(
    id: 'confirmation',
    title: 'Confirmation',
    subtitle: 'showPlatformConfirmation returns a bool',
    icon: Icons.help_outline,
    run: (context, style) async {
      final save = await showPlatformConfirmation(
        context: context,
        style: style,
        title: 'Save changes?',
        message: 'Your edits will be saved to this device.',
        confirmLabel: 'Save',
      );
      return save ? 'Saved' : 'Not saved';
    },
  ),
  Demo(
    id: 'destructive',
    title: 'Destructive confirmation',
    subtitle: 'isDestructive styles both platforms',
    icon: Icons.delete_outline,
    run: (context, style) async {
      final discard = await showPlatformConfirmation(
        context: context,
        style: style,
        title: 'Discard draft?',
        message: 'This cannot be undone.',
        confirmLabel: 'Discard',
        isDestructive: true,
      );
      return discard ? 'Draft discarded' : 'Draft kept';
    },
  ),
  Demo(
    id: 'custom',
    title: 'Custom actions',
    subtitle: 'BasicDialogAlert with three actions',
    icon: Icons.tune,
    run: (context, style) {
      return showPlatformDialog<String>(
        context: context,
        style: style,
        builder: (dialogContext) => BasicDialogAlert(
          style: style,
          title: const Text('Allow notifications?'),
          content: const Text(
            'Get a reminder when someone replies to your post.',
          ),
          actions: [
            BasicDialogAction(
              style: style,
              title: const Text("Don't allow"),
              onPressed: () => Navigator.of(dialogContext).pop('Denied'),
            ),
            BasicDialogAction(
              style: style,
              title: const Text('Not now'),
              onPressed: () => Navigator.of(dialogContext).pop('Later'),
            ),
            BasicDialogAction(
              style: style,
              isDefaultAction: true,
              title: const Text('Allow'),
              onPressed: () => Navigator.of(dialogContext).pop('Allowed'),
            ),
          ],
        ),
      );
    },
  ),
  Demo(
    id: 'list',
    title: 'List content',
    subtitle: 'Any widget as content',
    icon: Icons.list,
    run: (context, style) {
      const accounts = [
        'hi@example.com',
        'joshua@joshuamdeguzman.com',
        'joshua@flutter.ph',
        'team@flutter.ph',
      ];
      return showPlatformDialog<String>(
        context: context,
        style: style,
        builder: (dialogContext) => BasicDialogAlert(
          style: style,
          title: const Text('Select account'),
          content: Material(
            type: MaterialType.transparency,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final account in accounts)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.account_circle_outlined),
                    title: Text(account),
                    onTap: () => Navigator.of(dialogContext).pop(account),
                  ),
              ],
            ),
          ),
          actions: [
            BasicDialogAction(
              style: style,
              title: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        ),
      );
    },
  ),
  Demo(
    id: 'sheet',
    title: 'Action sheet',
    subtitle: 'showPlatformActionSheet returns the picked value',
    icon: Icons.ios_share,
    run: (context, style) {
      return showPlatformActionSheet<String>(
        context: context,
        style: style,
        title: 'Share photo',
        message: 'Choose how you want to share it.',
        actions: const [
          PlatformSheetAction(
            label: 'Copy link',
            value: 'Link copied',
            icon: Icon(Icons.link),
          ),
          PlatformSheetAction(
            label: 'Send in a message',
            value: 'Sent',
            icon: Icon(Icons.chat_bubble_outline),
          ),
          PlatformSheetAction(
            label: 'Save to files',
            value: 'Saved to files',
            icon: Icon(Icons.download_outlined),
          ),
          PlatformSheetAction(
            label: 'Delete photo',
            value: 'Photo deleted',
            icon: Icon(Icons.delete_outline),
            isDestructiveAction: true,
          ),
        ],
      );
    },
  ),
  Demo(
    id: 'dismissible',
    title: 'Tap outside to close',
    subtitle: 'barrierDismissible works on every platform',
    icon: Icons.touch_app_outlined,
    run: (context, style) async {
      await showPlatformDialog<void>(
        context: context,
        style: style,
        barrierDismissible: true,
        builder: (_) => BasicDialogAlert(
          style: style,
          title: const Text('Tip'),
          content: const Text('Tap anywhere outside this dialog to close it.'),
        ),
      );
      return 'Dialog closed';
    },
  ),
  Demo(
    id: 'overrides',
    title: 'Per-platform overrides',
    subtitle: 'android and ios builders',
    icon: Icons.devices,
    run: (context, style) async {
      await showPlatformDialog<void>(
        context: context,
        style: style,
        builder: (dialogContext) => BasicDialogAlert(
          style: style,
          title: const Text('Update available'),
          content: const Text('A new version is ready to install.'),
          android: (_) => const BasicDialogAlertData(
            content: Text('Get the new version from Google Play.'),
          ),
          ios: (_) => const BasicDialogAlertData(
            content: Text('Get the new version from the App Store.'),
          ),
          actions: [
            BasicDialogAction(
              style: style,
              isDefaultAction: true,
              title: const Text('OK'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        ),
      );
      return 'Dialog closed';
    },
  ),
];

class DemoGallery extends StatefulWidget {
  const DemoGallery({super.key});

  @override
  State<DemoGallery> createState() => _DemoGalleryState();
}

class _DemoGalleryState extends State<DemoGallery> {
  PlatformDialogStyle _style = PlatformDialogStyle.adaptive;

  @override
  void initState() {
    super.initState();
    if (_autoOpenDemo.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final demo = demos.where((d) => d.id == _autoOpenDemo).firstOrNull;
        if (demo != null && mounted) _run(demo);
      });
    }
  }

  Future<void> _run(Demo demo) async {
    final result = await demo.run(context, _style);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(result ?? 'Cancelled')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_dialogs')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text('Style', style: theme.textTheme.labelLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<PlatformDialogStyle>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: PlatformDialogStyle.adaptive,
                  label: Text('Adaptive'),
                ),
                ButtonSegment(
                  value: PlatformDialogStyle.material,
                  label: Text('Material'),
                ),
                ButtonSegment(
                  value: PlatformDialogStyle.cupertino,
                  label: Text('Cupertino'),
                ),
              ],
              selected: {_style},
              onSelectionChanged: (s) => setState(() => _style = s.first),
            ),
          ),
          const SizedBox(height: 8),
          for (final demo in demos)
            ListTile(
              leading: Icon(demo.icon),
              title: Text(demo.title),
              subtitle: Text(demo.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _run(demo),
            ),
        ],
      ),
    );
  }
}
