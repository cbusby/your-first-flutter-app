import 'dart:developer';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MyAppThemeContainer(),
    );
  }
}

class MyAppThemeContainer extends StatelessWidget {
  const MyAppThemeContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAppState>(
      builder: (context, myAppState, child) {
        return MaterialApp(
          title: 'Namer App',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme:
                themeFromSeed(myAppState.themeColor, myAppState.isLightTheme),
          ),
          home: MyHomePage(),
        );
      },
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var themeColor = Colors.pink;
  var isLightTheme = true;

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    log(favorites.toString());
    notifyListeners();
  }

  void removeFavorite(WordPair toBeRemoved) {
    if (favorites.contains(toBeRemoved)) {
      favorites.remove(toBeRemoved);
    } else {
      log("no word detected");
    }
    notifyListeners();
  }

  void changeThemeColor(MaterialColor newColor) {
    themeColor = newColor;
    notifyListeners();
  }

  void activateLightMode() {
    isLightTheme = true;
    notifyListeners();
  }

  void activateDarkMode() {
    isLightTheme = false;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavViewPage();
        break;
      case 2:
        page = SettingsPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class SettingsPage extends StatelessWidget {
  final themeColors = [
    Colors.pink,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.purple
  ];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Column(
      children: [
        Text('\n\nChoose theme color:',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var color in themeColors)
              GestureDetector(
                onTap: () {
                  appState.changeThemeColor(color);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  color: color,
                  child: Icon(Icons.brush,
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
          ],
        ),
        Text('\n\nChoose light or dark:',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            GestureDetector(
                onTap: () {
                  appState.activateLightMode();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  color: Theme.of(context).colorScheme.background,
                  child: Icon(
                    Icons.brightness_low,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                )),
            GestureDetector(
                onTap: () {
                  appState.activateDarkMode();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  color: Theme.of(context).colorScheme.background,
                  child: Icon(
                    Icons.bedtime,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ))
          ],
        ),
      ],
    );
  }
}

class FavViewPage extends StatelessWidget {
  const FavViewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              if (appState.favorites.isNotEmpty)
                for (var message in appState.favorites)
                  ElevatedButton.icon(
                    onPressed: () {
                      appState.removeFavorite(message);
                    },
                    icon: Icon(Icons.delete),
                    label: Text(message.asLowerCase),
                  ),
              if (appState.favorites.isEmpty)
                ListTile(
                  title: Text(
                    'Go to the home page to add favorites',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.primary,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          key: Key('generatedWord'),
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

ColorScheme themeFromSeed(Color seedColor, bool isLightTheme) {
  final primaryColor = seedColor;
  final secondaryColor = seedColor.withOpacity(0.8);
  if (isLightTheme) {
    return ColorScheme(
      primary: Colors.white,
      primaryContainer: Color.fromARGB(255, 244, 241, 241),
      secondary: secondaryColor,
      secondaryContainer: Colors.white,
      background: Colors.white,
      surface: primaryColor,
      error: Colors.red,
      onPrimary: primaryColor,
      onSecondary: primaryColor,
      onBackground: primaryColor,
      onSurface: Colors.white,
      onError: Colors.white,
      brightness: Brightness.light,
    );
  }

  const brightness = Brightness.dark;

  final colorScheme = ColorScheme(
    primary: Color.fromARGB(255, 52, 53, 54),
    primaryContainer: Color.fromARGB(255, 52, 53, 54),
    secondary: secondaryColor,
    secondaryContainer: Colors.black,
    background: Colors.black,
    surface: primaryColor,
    error: Colors.red,
    onPrimary: primaryColor,
    onSecondary: primaryColor,
    onBackground: primaryColor,
    onSurface: Colors.black,
    onError: Colors.black,
    brightness: brightness,
  );

  return colorScheme;
}
