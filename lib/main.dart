import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'DB/dbhelper.dart';
import 'Screen/homescreen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initializeDB();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: ChangeThemeProvider(
        child: HomeScreen(),
      ),
    );
  }
}

class ChangeThemeProvider extends StatefulWidget {
  final Widget child;

  ChangeThemeProvider({required this.child});

  @override
  _ChangeThemeProviderState createState() => _ChangeThemeProviderState();

  static _ChangeThemeProviderState of(BuildContext context) {
    return context.findAncestorStateOfType<_ChangeThemeProviderState>()!;
  }
}

class _ChangeThemeProviderState extends State<ChangeThemeProvider> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: widget.child,
    );
  }
}