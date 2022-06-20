import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../game.dart';
import 'plat.dart';

class Tebe extends SpriteAnimationComponent
    with HasGameRef<TebeFallGame>, CollisionCallbacks {
  static const double tebeWidth = 40.0;
  static const double tebeHeight = 40.0;

  Vector2 velocity = Vector2(0, 0);
  bool onGround = true;
  Plat plat;
  double gravity = 5;

  Tebe({required this.plat})
      : super(
          size: Vector2(tebeWidth, tebeHeight),
          anchor: Anchor.topLeft,
        ) {
    // debugMode = true;
    add(RectangleHitbox());
  }

  @override
  Future<void>? onLoad() async {
    final spriteSheet = SpriteSheet(
        image: await gameRef.images.load('tebe_spritesheet.png'),
        srcSize: Vector2(426, 426));

    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.05, to: 12);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (onGround) {
      velocity.y = plat.velocity.y;
    } else {
      velocity.y += gravity;
    }

    if (y + height < 0 || y > gameRef.size.y) {
      onGround = false;

      velocity.x = 0;
      velocity.y = 120;

      x = gameRef.size.x / 2;
      y = gameRef.size.y / 2;
    }

    if (velocity.y > 200) {
      velocity.y = 200;
    }

    position += velocity * dt;
    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Plat &&
        other != plat &&
        onGround == false &&
        (x + width > other.x + 5 && x < other.x + other.width - 5)) {
      gameRef.score += 10;

      onGround = true;
      plat = other;

      velocity.x = 0;
      y = plat.y - Tebe.tebeHeight + 1;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (onGround == true) {
      velocity.y = 20;
      onGround = false;
    }
  }
}
