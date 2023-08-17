// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  group("Main page", () {
    test('Like a word', () {
      // Build our app and trigger a frame.
      final notifier =
          MyAppState(); // Create an instance of your ChangeNotifier

      expect(notifier.favorites,
          isEmpty); // Verify that the list is initially empty

      notifier.toggleFavorite();

      expect(notifier.favorites, hasLength(1));
    });

    test('Unlike a word', () {
      // Build our app and trigger a frame.
      final notifier =
          MyAppState(); // Create an instance of your ChangeNotifier

      expect(notifier.favorites,
          isEmpty); // Verify that the list is initially empty

      notifier.toggleFavorite();

      expect(notifier.favorites, hasLength(1));

      notifier.toggleFavorite();

      expect(notifier.favorites, isEmpty);
    });

    test("Remove a favorite", () {
      final notifier = MyAppState();

      expect(notifier.current, isNotNull);

      notifier.toggleFavorite();
      expect(notifier.favorites, hasLength(1));

      var toRemove = notifier.favorites.firstOrNull;
      notifier.removeFavorite(toRemove!);

      expect(notifier.favorites, isEmpty);
    });

    test('Get next word', () {
      // Build our app and trigger a frame.
      final notifier =
          MyAppState(); // Create an instance of your ChangeNotifier

      expect(notifier.current,
          isNotNull); // Verify that the list is initially empty
      var oldWord = notifier.current;

      notifier.getNext();

      expect(notifier.current == oldWord, isFalse);
    });
  });

  testWidgets('Clicking NavigationRail item navigates to the right page',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp()); // Build the app

    // Tap on a NavigationRail item
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle(); // Wait for the navigation to complete

    // Verify that the app is now on the expected page
    expect(find.text('Go to the home page to add favorites'), findsOneWidget);
  });
}
