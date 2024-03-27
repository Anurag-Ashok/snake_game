import 'package:flutter/material.dart';
import 'package:snake_game/gamePage.dart';

void main() => runApp(SnakeGame());

class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snake Game',
      home: SnakeGamePage(),
    );
  }
}
