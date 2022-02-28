import 'package:barcode_validator/screens/home_screen.dart';
import 'package:barcode_validator/services/application_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
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
      theme: ThemeData(
          // primarySwatch: Colors.blue,
          useMaterial3: true,
          floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.green, foregroundColor: Colors.green[200]!, iconSize: 40),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          listTileTheme: ListTileTheme.of(context).copyWith(selectedTileColor: Colors.blue[200], tileColor: Colors.blue[100]),
          iconTheme: IconTheme.of(context).copyWith(color: Colors.blue[800])),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
