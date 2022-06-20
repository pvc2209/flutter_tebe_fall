import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game.dart';
import '../widgets/game_over.dart';
import '../widgets/top_panel.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: TebeFallGame(),
        overlayBuilderMap: {
          TopPanelWidget.id: (BuildContext context, TebeFallGame gameRef) {
            return TopPanelWidget(
              gameRef: gameRef,
            );
          },
          GameOver.id: (BuildContext context, TebeFallGame gameRef) {
            return GameOver(
              gameRef: gameRef,
            );
          },
        },
        // Không gọi overlays.add() ở bên trong onload() của game (gọi ở đấy sẽ ko working),
        // mà phải dùng initialActiveOverlays
        initialActiveOverlays: const [TopPanelWidget.id],

        backgroundBuilder: (context) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.gif"),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
