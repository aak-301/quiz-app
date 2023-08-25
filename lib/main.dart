import 'package:flutter/material.dart';
import 'package:game/provider/game_provider.dart';
import 'package:game/screens/game_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quiz',
        theme: ThemeData(),
        home: const GameScreen(),
      ),
    );
  }
}
