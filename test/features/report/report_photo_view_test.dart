import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:clean_spot/features/report/report_photo_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A valid 1x1 PNG.
final Uint8List _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('shows a placeholder while the photo is loading', (tester) async {
    final pending = Completer<Uint8List?>();
    await tester.pumpWidget(
      host(ReportPhotoView(reportId: 'r1', loader: (_) => pending.future)),
    );
    expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('shows the photo once it has loaded', (tester) async {
    await tester.pumpWidget(
      host(ReportPhotoView(reportId: 'r1', loader: (_) async => _png)),
    );
    await tester.pump();
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('keeps the placeholder when the photo is missing', (tester) async {
    await tester.pumpWidget(
      host(ReportPhotoView(reportId: 'r1', loader: (_) async => null)),
    );
    await tester.pump();
    expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('keeps the placeholder when loading throws', (tester) async {
    // The loader contract returns null on failure; a throwing loader must not
    // crash the list either.
    await tester.pumpWidget(
      host(
        ReportPhotoView(
          reportId: 'r1',
          loader: (_) async => throw Exception('offline'),
        ),
      ),
    );
    await tester.pump();
    expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('does not load anything for an empty report id', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      host(
        ReportPhotoView(
          reportId: '',
          loader: (_) async {
            calls++;
            return _png;
          },
        ),
      ),
    );
    await tester.pump();
    expect(calls, 0);
    expect(find.byIcon(Icons.image_outlined), findsOneWidget);
  });

  testWidgets('loads each report id once, and again when the id changes',
      (tester) async {
    final loaded = <String>[];
    Future<Uint8List?> loader(String id) async {
      loaded.add(id);
      return _png;
    }

    await tester.pumpWidget(host(ReportPhotoView(reportId: 'a', loader: loader)));
    await tester.pump();
    await tester.pumpWidget(host(ReportPhotoView(reportId: 'a', loader: loader)));
    await tester.pump();
    expect(loaded, ['a']);

    await tester.pumpWidget(host(ReportPhotoView(reportId: 'b', loader: loader)));
    await tester.pump();
    expect(loaded, ['a', 'b']);
  });
}
