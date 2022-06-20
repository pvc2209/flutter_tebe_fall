import 'dart:ui';

import 'package:flutter/material.dart';

import '../game.dart';

class GameOver extends StatefulWidget {
  static const String id = "GameOver";
  const GameOver({
    Key? key,
    required this.gameRef,
  }) : super(key: key);

  final TebeFallGame gameRef;

  @override
  State<GameOver> createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20,
              sigmaY: 20,
            ),
            child: Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(36),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "YOUR SCORE\n${widget.gameRef.score}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.arrow_back,
                    color: Colors.yellow,
                    size: 60,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
