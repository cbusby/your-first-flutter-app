import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('favorite a word and then view it in the list and delete it',
        (tester) async {
      await tester.pumpWidget(const MyApp());

      var widgetFinder = find.byKey(Key('generatedWord'));
      expect(widgetFinder, findsOneWidget);

      var startingWord = tester.widget<Text>(widgetFinder).data;
      expect(startingWord, isNotNull);

      await tester.tap(find.text('Like'));

      // Rebuild the widget after the state has changed.
      await tester.pump();

      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle(); // Wait for the navigation to complete

      expect(find.text(startingWord!), findsOneWidget);
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      expect(find.text('Go to the home page to add favorites'), findsOneWidget);
    });
  });
}
