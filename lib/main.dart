import 'package:barcode_validator/screens/home_screen.dart';
import 'package:barcode_validator/services/application_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appConfig = await ApplicationConfig.getInstance();
  runApp(ProviderScope(
    child: const MyApp(),
    overrides: [providerApplicationConfig.overrideWithValue(appConfig)],
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const ScrollBehavior().copyWith(dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch}),
      title: 'Barcode validator',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple[900]!,
          brightness: Brightness.dark,
          surface: Colors.indigo[900],
          primaryContainer: Colors.blue[900],
          secondaryContainer: Colors.deepPurple[900],
          tertiaryContainer: Colors.yellow,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.purple[700],
          labelPadding: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(0),
          selectedColor: Colors.deepPurple[900],
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(fontSize: 14),
          bodyText2: TextStyle(fontSize: 12),
        ),
        cardColor: Colors.deepPurple[900],
        bottomAppBarColor: Colors.indigo[900],
      ),
      theme: ThemeData(
          // primarySwatch: Colors.blue,
          useMaterial3: true,
          textTheme: const TextTheme(
            bodyText2: TextStyle(fontSize: 14),
            bodyText1: TextStyle(fontSize: 12),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.green[800], foregroundColor: Colors.green[200]!, iconSize: 40),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          listTileTheme: ListTileTheme.of(context).copyWith(selectedTileColor: Colors.blue[200], tileColor: Colors.blue[100]),
          chipTheme: ChipThemeData(
            backgroundColor: Colors.blue[100],
            padding: const EdgeInsets.all(0),
            selectedColor: Colors.blue[200],
          ),
          bottomAppBarColor: Colors.lightBlue[50],
          iconTheme: IconTheme.of(context).copyWith(color: Colors.blue[800])),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
