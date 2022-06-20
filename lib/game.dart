import 'dart:math';

import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'components/tebe.dart';

import 'components/plat.dart';
import 'spref/spref.dart';
import 'widgets/game_over.dart';

class TebeFallGame extends FlameGame with HasCollisionDetection, TapDetector {
  late Tebe tebe;

  final List<Plat> plats = [];
  late Plat lastPlat; // ball have lowest y

  bool gameOver = false;

  int numberOfPlats = 10;
  int score = 0;
  bool canSpeedUp = true;

  List<Vector2> initRandomPlatPositions = [];

  static int distanceBetweenPlats = 100;

  @override
  Future<void>? onLoad() async {
    // Random plat positions
    initRandomPlatPositions.add(Vector2(
        Random().nextInt(size.x.toInt() - Plat.platWidth.toInt()).toDouble(),
        size.y));

    for (int i = 1; i < numberOfPlats; i++) {
      Vector2 position = Vector2(
        Random().nextInt(size.x.toInt() - Plat.platWidth.toInt()).toDouble(),
        initRandomPlatPositions[i - 1].y + distanceBetweenPlats,
      );

      initRandomPlatPositions.add(position);
    }

    for (int i = 0; i < initRandomPlatPositions.length; ++i) {
      plats.add(
        Plat()
          ..x = initRandomPlatPositions[i].x
          ..y = initRandomPlatPositions[i].y,
      );
    }

    for (final plat in plats) {
      add(plat);
    }

    lastPlat = plats.last;

    tebe = Tebe(plat: plats.first)
      ..x = plats.first.x + plats.first.width / 2 - Tebe.tebeWidth / 2
      ..y = plats.first.y - Tebe.tebeHeight + 1
      ..onGround = true;

    add(tebe);

    return super.onLoad();
  }

  void endGame() {
    gameOver = true;
    overlays.add(GameOver.id);

    saveHighScore();
  }

  void saveHighScore() async {
    int top1 = await SPref.instance.getInt("top1") ?? 0;
    int top2 = await SPref.instance.getInt("top2") ?? 0;
    int top3 = await SPref.instance.getInt("top3") ?? 0;

    if (score > top1) {
      SPref.instance.setInt("top1", score);
      SPref.instance.setInt("top2", top1);
      SPref.instance.setInt("top3", top2);
    } else if (score > top2) {
      SPref.instance.setInt("top2", score);
      SPref.instance.setInt("top3", top2);
    } else if (score > top3) {
      SPref.instance.setInt("top3", score);
    }
  }

  @override
  void update(double dt) {
    if (!gameOver) {
      super.update(dt);

      // update plats y speed
      if (score > 0 && score % 100 == 0) {
        if (canSpeedUp) {
          for (final plat in plats) {
            if (plat.velocity.y <= 220) {
              plat.velocity.y -= 10;
            } else {
              plat.velocity.y -= 5;
            }
          }

          canSpeedUp = false;
        }
      } else {
        canSpeedUp = true;
      }
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (info.eventPosition.game.x < size.x / 2 - 10) {
      tebe.velocity.x = -120;
    } else if (info.eventPosition.game.x > size.x / 2 + 10) {
      tebe.velocity.x = 120;
    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    super.onTapUp(info);

    if (tebe.onGround) {
      tebe.velocity.x = 0;
    }
  }
}
