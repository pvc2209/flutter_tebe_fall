import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../game.dart';
import '../widgets/top_panel.dart';

class Plat extends SpriteComponent with HasGameRef<TebeFallGame> {
  static const double platWidth = 90.5;
  static const double platHeight = 9.8;
  Vector2 velocity = Vector2(0, -120);

  Plat()
      : super(
          size: Vector2(platWidth, platHeight),
          anchor: Anchor.topLeft,
        ) {
    // debugMode = true;
    add(RectangleHitbox());
  }

  @override
  Future<void>? onLoad() async {
    sprite = await gameRef.loadSprite("plat.png");
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (y + height < 0) {
      x = Random().nextInt(gameRef.size.x.toInt() - width.toInt()).toDouble();

      y = gameRef.lastPlat.y + TebeFallGame.distanceBetweenPlats;

      gameRef.lastPlat = this;

      // add score
      gameRef.score++;
      gameRef.overlays.remove(TopPanelWidget.id);
      gameRef.overlays.add(TopPanelWidget.id);
    } else {
      position += velocity * dt;
    }
  }
}
