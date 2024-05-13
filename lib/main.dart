import 'package:cryptool/view/desktop/home_page.dart';
import 'package:cryptool/view/phone/phone_home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'Cryptool Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: width > 450 ?
          HomePage() : PhoneHomePage()
      );
  }
}

