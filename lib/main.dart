import 'package:flutter/cupertino.dart';
import '../tabs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
        title: 'Expense Tracker',
        theme: CupertinoThemeData(
            primaryColor: Color.fromARGB(255, 41, 141, 255),
            brightness: Brightness.light),
        home: TabsController());
  }
}
