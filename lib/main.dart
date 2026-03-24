import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spotify Clone',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color.fromARGB(255, 30, 215, 96),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 30, 215, 96),
          secondary: Color.fromARGB(255, 30, 215, 96),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
