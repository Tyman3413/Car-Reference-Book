import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:car_reference_book/services/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
  if (isFirstRun) {
    await dbHelper.fillDatabase();
    await prefs.setBool('isFirstRun', false);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Reference Book',
      theme: ThemeData(
        primaryColor: Colors.grey,
      ),
      home: AnimatedSplashScreen(
        duration: 1500,
        splash: const Icon(
          Icons.build,
          size: 150,
        ),
        nextScreen: HomeScreen(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white,
      ),
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        DiscoverScreen.routeName: (context) => DiscoverScreen(),
        ArticleScreen.routeName: (context) => ArticleScreen(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
      },
    );
  }
}
