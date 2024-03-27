import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SnakeGamePage extends StatefulWidget {
  @override
  _SnakeGamePageState createState() => _SnakeGamePageState();
}

class _SnakeGamePageState extends State<SnakeGamePage> {
  final int rows = 20;
  final int cols = 20;
  final int initialSnakeLength = 3;
  final Duration snakeSpeed = Duration(milliseconds: 300);

  List<int> snake = [];
  int food = -1;
  Direction direction = Direction.right;
  bool isPlaying = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    snake.clear();
    final int startIndex = (rows * cols) ~/ 2;
    for (int i = 0; i < initialSnakeLength; i++) {
      snake.add(startIndex - i);
    }
    generateFood();
    isPlaying = true;
    direction = Direction.right;
    score = 0;
    Timer.periodic(snakeSpeed, (Timer timer) {
      if (!isPlaying) return;
      moveSnake();
      if (checkCollision()) {
        timer.cancel();
        gameOver();
      }
    });
  }

  void moveSnake() {
    int newHead;
    switch (direction) {
      case Direction.up:
        newHead = snake.first - cols;
        break;
      case Direction.down:
        newHead = snake.first + cols;
        break;
      case Direction.left:
        newHead = snake.first - 1;
        break;
      case Direction.right:
        newHead = snake.first + 1;
        break;
    }
    setState(() {
      if (snake.contains(newHead) ||
          newHead < 0 ||
          newHead >= rows * cols ||
          (snake.first % cols == 0 && newHead % cols == cols - 1) ||
          (snake.first % cols == cols - 1 && newHead % cols == 0)) {
        isPlaying = false;
      } else {
        snake.insert(0, newHead);
        if (newHead == food) {
          score++;
          generateFood();
        } else {
          snake.removeLast();
        }
      }
    });
  }

  bool checkCollision() {
    return !isPlaying ||
        snake.first < 0 ||
        snake.first >= rows * cols ||
        snake.sublist(1).contains(snake.first);
  }

  void gameOver() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Your score: $score'),
          actions: <Widget>[
            TextButton(
              child: Text('Restart'),
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
            ),
          ],
        );
      },
    );
  }

  void generateFood() {
    setState(() {
      food = Random().nextInt(rows * cols);
      while (snake.contains(food)) {
        food = Random().nextInt(rows * cols);
      }
    });
  }

  void onUpPressed() {
    if (direction != Direction.down) {
      direction = Direction.up;
    }
  }

  void onDownPressed() {
    if (direction != Direction.up) {
      direction = Direction.down;
    }
  }

  void onLeftPressed() {
    if (direction != Direction.right) {
      direction = Direction.left;
    }
  }

  void onRightPressed() {
    if (direction != Direction.left) {
      direction = Direction.right;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> gridChildren = [];
    for (int i = 0; i < rows * cols; i++) {
      gridChildren.add(Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: const Color.fromARGB(255, 253, 252, 252)),
          color: snake.contains(i)
              ? Colors.green
              : i == food
                  ? Colors.red
                  : Colors.white,
        ),
      ));
    }
    return Scaffold(
      //backgroundColor: Color.fromARGB(1000, 155, 207, 83),
      appBar: AppBar(
        title: Text(
          'Snake Game',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .54,
            width: MediaQuery.of(context).size.width * .99,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black)),
            child: Expanded(
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < 0) {
                    onUpPressed();
                  } else if (details.delta.dy > 0) {
                    onDownPressed();
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx < 0) {
                    onLeftPressed();
                  } else if (details.delta.dx > 0) {
                    onRightPressed();
                  }
                },
                child: GridView.count(
                  crossAxisCount: cols,
                  children: gridChildren,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * .33,
              width: MediaQuery.of(context).size.width * .9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      onUpPressed();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(100, 191, 234, 124),
                          border: Border.all(color: Colors.black)),
                      height: MediaQuery.of(context).size.width * .2,
                      width: MediaQuery.of(context).size.height * .43,
                      child: Icon(Icons.keyboard_arrow_up_sharp, size: 60),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          onLeftPressed();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(100, 191, 234, 124),
                              border: Border.all(color: Colors.black)),
                          height: MediaQuery.of(context).size.width * .23,
                          width: MediaQuery.of(context).size.height * .15,
                          child: Icon(Icons.keyboard_arrow_left, size: 60),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          onRightPressed();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(100, 191, 234, 124),
                              border: Border.all(color: Colors.black)),
                          height: MediaQuery.of(context).size.width * .23,
                          width: MediaQuery.of(context).size.height * .15,
                          child: Icon(Icons.keyboard_arrow_right_outlined,
                              size: 60),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      onDownPressed();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(100, 191, 234, 124),
                          border: Border.all(color: Colors.black)),
                      height: MediaQuery.of(context).size.width * .2,
                      width: MediaQuery.of(context).size.height * .43,
                      child: Icon(Icons.keyboard_arrow_down, size: 60),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum Direction { up, down, left, right }
