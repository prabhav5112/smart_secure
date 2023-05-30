import 'package:flutter/material.dart';
import 'mfiles.dart';
import 'murls.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Smart Secure';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(
          children: [
            MaliciousApps(),
            MaliciousUrls(),
          ],
        ),
        bottomNavigationBar: ColoredBox(
          color: Colors.black54,
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.file_present_outlined)),
              Tab(icon: Icon(Icons.link)),
            ],
          ),
        ),
      ),
    ));
  }
}
