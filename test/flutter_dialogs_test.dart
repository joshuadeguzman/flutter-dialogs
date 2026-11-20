// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps an app whose theme reports [platform], and returns a context below
/// the [MaterialApp] navigator.
Future<BuildContext> pumpApp(
  WidgetTester tester,
  TargetPlatform platform,
) async {
  late BuildContext captured;
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(platform: platform),
      home: Scaffold(
        body: Builder(
          builder: (context) {
            captured = context;
            return const SizedBox.expand();
          },
        ),
      ),
    ),
  );
  return captured;
}

BasicDialogAlert sampleAlert({
  PlatformDialogStyle style = PlatformDialogStyle.adaptive,
  Widget? icon,
}) {
  return BasicDialogAlert(
    style: style,
    icon: icon,
    title: const Text('Title'),
    content: const Text('Content'),
    actions: [
      BasicDialogAction(
          style: style, title: const Text('OK'), onPressed: () {}),
    ],
  );
}

void main() {
  group('resolvePlatformDialogStyle', () {
    for (final (platform, expected) in [
      (TargetPlatform.iOS, PlatformDialogStyle.cupertino),
      (TargetPlatform.macOS, PlatformDialogStyle.cupertino),
      (TargetPlatform.android, PlatformDialogStyle.material),
      (TargetPlatform.fuchsia, PlatformDialogStyle.material),
      (TargetPlatform.linux, PlatformDialogStyle.material),
      (TargetPlatform.windows, PlatformDialogStyle.material),
    ]) {
      testWidgets('adaptive on ${platform.name} is ${expected.name}',
          (tester) async {
        final context = await pumpApp(tester, platform);
        expect(resolvePlatformDialogStyle(context), expected);
      });
    }

    testWidgets('an explicit style wins over the platform', (tester) async {
      final context = await pumpApp(tester, TargetPlatform.iOS);
      expect(
        resolvePlatformDialogStyle(context, PlatformDialogStyle.material),
        PlatformDialogStyle.material,
      );
    });
  });

  group('showPlatformDialog', () {
    testWidgets('shows a CupertinoAlertDialog on iOS', (tester) async {
      final context = await pumpApp(tester, TargetPlatform.iOS);
      showPlatformDialog<void>(context: context, builder: (_) => sampleAlert());
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(CupertinoDialogAction), findsOneWidget);
    });

    testWidgets('shows an AlertDialog on Android', (tester) async {
      final context = await pumpApp(tester, TargetPlatform.android);
      showPlatformDialog<void>(context: context, builder: (_) => sampleAlert());
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(CupertinoAlertDialog), findsNothing);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('style forces Cupertino on Android', (tester) async {
      final context = await pumpApp(tester, TargetPlatform.android);
      showPlatformDialog<void>(
        context: context,
        style: PlatformDialogStyle.cupertino,
        builder: (_) => sampleAlert(style: PlatformDialogStyle.cupertino),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    testWidgets('returns the value passed to Navigator.pop', (tester) async {
      final context = await pumpApp(tester, TargetPlatform.android);
      final future = showPlatformDialog<String>(
        context: context,
        builder: (dialogContext) => BasicDialogAlert(
          actions: [
            BasicDialogAction(
              title: const Text('Pick'),
              onPressed: () => Navigator.of(dialogContext).pop('picked'),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pick'));
      await tester.pumpAndSettle();

      expect(await future, 'picked');
    });

    for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
      testWidgets(
          'barrierDismissible closes on tap outside on ${platform.name}',
          (tester) async {
        final context = await pumpApp(tester, platform);
        showPlatformDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (_) => sampleAlert(),
        );
        await tester.pumpAndSettle();
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        expect(find.text('Title'), findsNothing);
      });

      testWidgets('is not dismissible by default on ${platform.name}',
          (tester) async {
        final context = await pumpApp(tester, platform);
        showPlatformDialog<void>(
            context: context, builder: (_) => sampleAlert());
        await tester.pumpAndSettle();
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        expect(find.text('Title'), findsOneWidget);
      });
    }

    testWidgets('deprecated androidBarrierDismissible still works',
        (tester) async {
      final context = await pumpApp(tester, TargetPlatform.android);
      showPlatformDialog<void>(
        context: context,
        androidBarrierDismissible: true,
        builder: (_) => sampleAlert(),
      );
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text('Title'), findsNothing);
    });
  });

  group('BasicDialogAlert', () {
    for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
      testWidgets('shows the icon on ${platform.name}', (tester) async {
        final context = await pumpApp(tester, platform);
        showPlatformDialog<void>(
          context: context,
          builder: (_) => sampleAlert(icon: const Icon(Icons.wifi_off)),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.wifi_off), findsOneWidget);
        expect(find.text('Title'), findsOneWidget);
      });
    }

    for (final (platform, expected) in [
      (TargetPlatform.android, 'Android'),
      (TargetPlatform.iOS, 'iOS'),
    ]) {
      testWidgets('uses the $expected override on ${platform.name}',
          (tester) async {
        final context = await pumpApp(tester, platform);
        showPlatformDialog<void>(
          context: context,
          builder: (_) => BasicDialogAlert(
            title: const Text('Shared'),
            content: const Text('Shared content'),
            android: (_) => const BasicDialogAlertData(title: Text('Android')),
            ios: (_) => const BasicDialogAlertData(title: Text('iOS')),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(expected), findsOneWidget);
        expect(find.text('Shared'), findsNothing);
        expect(find.text('Shared content'), findsOneWidget);
      });
    }
  });

  group('BasicDialogAction', () {
    testWidgets('destructive uses the error color on Material', (tester) async {
      final context = await pumpApp(tester, TargetPlatform.android);
      final error = Theme.of(context).colorScheme.error;
      showPlatformDialog<void>(
        context: context,
        builder: (_) => BasicDialogAlert(
          actions: [
            BasicDialogAction(
              isDestructiveAction: true,
              title: const Text('Delete'),
              onPressed: () {},
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final button = tester.widget<TextButton>(find.byType(TextButton));
      expect(button.style?.foregroundColor?.resolve({}), error);
    });

    testWidgets('default action is bold on Material', (tester) async {
      final context = await pumpApp(tester, TargetPlatform.android);
      showPlatformDialog<void>(
        context: context,
        builder: (_) => BasicDialogAlert(
          actions: [
            BasicDialogAction(
              isDefaultAction: true,
              title: const Text('Save'),
              onPressed: () {},
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final text = tester.widget<RichText>(
        find.descendant(
            of: find.byType(TextButton), matching: find.byType(RichText)),
      );
      expect(text.text.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('maps the new and deprecated flags on Cupertino',
        (tester) async {
      final context = await pumpApp(tester, TargetPlatform.iOS);
      showPlatformDialog<void>(
        context: context,
        builder: (_) => BasicDialogAlert(
          actions: [
            BasicDialogAction(
              isDestructiveAction: true,
              title: const Text('New'),
              onPressed: () {},
            ),
            BasicDialogAction(
              iosIsDefaultAction: true,
              title: const Text('Old'),
              onPressed: () {},
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final actions = tester
          .widgetList<CupertinoDialogAction>(find.byType(CupertinoDialogAction))
          .toList();
      expect(actions[0].isDestructiveAction, isTrue);
      expect(actions[1].isDefaultAction, isTrue);
    });
  });

  group('showPlatformAlert', () {
    for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
      testWidgets('completes when OK is tapped on ${platform.name}',
          (tester) async {
        final context = await pumpApp(tester, platform);
        var done = false;
        showPlatformAlert(context: context, title: 'Saved', message: 'Done.')
            .then((_) => done = true);
        await tester.pumpAndSettle();
        expect(find.text('Done.'), findsOneWidget);

        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        expect(done, isTrue);
        expect(find.text('Saved'), findsNothing);
      });
    }
  });

  group('showPlatformConfirmation', () {
    for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
      testWidgets('returns true on confirm on ${platform.name}',
          (tester) async {
        final context = await pumpApp(tester, platform);
        final future = showPlatformConfirmation(
          context: context,
          title: 'Discard draft?',
          confirmLabel: 'Discard',
          isDestructive: true,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Discard'));
        await tester.pumpAndSettle();

        expect(await future, isTrue);
      });

      testWidgets('returns false on cancel on ${platform.name}',
          (tester) async {
        final context = await pumpApp(tester, platform);
        final future =
            showPlatformConfirmation(context: context, title: 'Discard draft?');
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(await future, isFalse);
      });
    }

    testWidgets('returns false when dismissed', (tester) async {
      final context = await pumpApp(tester, TargetPlatform.android);
      final future = showPlatformConfirmation(
        context: context,
        title: 'Discard draft?',
        barrierDismissible: true,
      );
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(await future, isFalse);
    });

    testWidgets('marks the confirm action destructive on Cupertino',
        (tester) async {
      final context = await pumpApp(tester, TargetPlatform.iOS);
      showPlatformConfirmation(
        context: context,
        title: 'Delete?',
        confirmLabel: 'Delete',
        isDestructive: true,
      );
      await tester.pumpAndSettle();

      final confirm = tester.widget<CupertinoDialogAction>(
        find.widgetWithText(CupertinoDialogAction, 'Delete'),
      );
      expect(confirm.isDestructiveAction, isTrue);
      expect(confirm.isDefaultAction, isFalse);
    });
  });

  group('showPlatformActionSheet', () {
    const actions = [
      PlatformSheetAction(
          label: 'Copy link', value: 'copy', icon: Icon(Icons.link)),
      PlatformSheetAction(
          label: 'Delete', value: 'delete', isDestructiveAction: true),
    ];

    testWidgets('shows a CupertinoActionSheet on iOS', (tester) async {
      final context = await pumpApp(tester, TargetPlatform.iOS);
      final future = showPlatformActionSheet<String>(
        context: context,
        title: 'Share',
        actions: actions,
      );
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoActionSheet), findsOneWidget);
      expect(find.byIcon(Icons.link), findsNothing);

      await tester.tap(find.text('Copy link'));
      await tester.pumpAndSettle();
      expect(await future, 'copy');
    });

    testWidgets('returns null on cancel on iOS', (tester) async {
      final context = await pumpApp(tester, TargetPlatform.iOS);
      final future =
          showPlatformActionSheet<String>(context: context, actions: actions);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(await future, isNull);
    });

    testWidgets('shows a bottom sheet with icons on Android', (tester) async {
      final context = await pumpApp(tester, TargetPlatform.android);
      final future = showPlatformActionSheet<String>(
        context: context,
        title: 'Share',
        message: 'Pick an option',
        actions: actions,
      );
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
      expect(find.byIcon(Icons.link), findsOneWidget);
      expect(find.text('Pick an option'), findsOneWidget);

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(await future, 'delete');
    });
  });

  group('3.x compatibility', () {
    testWidgets('androidBarrierDismissible does not make iOS dismissible',
        (tester) async {
      final context = await pumpApp(tester, TargetPlatform.iOS);
      showPlatformDialog<void>(
        context: context,
        androidBarrierDismissible: true,
        builder: (_) => sampleAlert(),
      );
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text('Title'), findsOneWidget);
    });

    for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
      testWidgets(
          'an override without actions keeps the shared actions on '
          '${platform.name}', (tester) async {
        final context = await pumpApp(tester, platform);
        showPlatformDialog<void>(
          context: context,
          builder: (_) => BasicDialogAlert(
            title: const Text('Shared'),
            actions: [
              BasicDialogAction(title: const Text('OK'), onPressed: () {}),
            ],
            android: (_) => const BasicDialogAlertData(title: Text('Android')),
            ios: (_) => const BasicDialogAlertData(title: Text('iOS')),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('OK'), findsOneWidget);
      });
    }

    testWidgets('an override can hide the actions with an empty list',
        (tester) async {
      final context = await pumpApp(tester, TargetPlatform.android);
      showPlatformDialog<void>(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: const Text('Shared'),
          actions: [
            BasicDialogAction(title: const Text('OK'), onPressed: () {}),
          ],
          android: (_) => const BasicDialogAlertData(actions: []),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('OK'), findsNothing);
    });
  });

  group('showPlatformActionSheet with a forced style', () {
    const actions = [PlatformSheetAction(label: 'Copy link', value: 'copy')];

    testWidgets('cupertino on Android', (tester) async {
      final context = await pumpApp(tester, TargetPlatform.android);
      showPlatformActionSheet<String>(
        context: context,
        style: PlatformDialogStyle.cupertino,
        actions: actions,
      );
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoActionSheet), findsOneWidget);
    });

    testWidgets('material on iOS', (tester) async {
      final context = await pumpApp(tester, TargetPlatform.iOS);
      showPlatformActionSheet<String>(
        context: context,
        style: PlatformDialogStyle.material,
        actions: actions,
      );
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
      expect(find.text('Cancel'), findsNothing);
    });
  });
}
