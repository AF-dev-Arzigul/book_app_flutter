import 'package:book_app_flutter/screens/book_page.dart';
import 'package:flutter/material.dart';
import 'di/di.dart';

void main() async {
  await setUp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const BookPage(),
    );
  }

}
