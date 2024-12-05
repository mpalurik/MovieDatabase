import 'package:flutter/material.dart';
import 'package:movie_app/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: Color.fromRGBO(120,6,6, 1)),
      appBarTheme: const AppBarTheme(backgroundColor:Color.fromRGBO(120,6,6, 1) ),
      textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.red,
      selectionHandleColor: Colors.white54,
    ),),
      home: const HomeScreen(),
    );
  }
}