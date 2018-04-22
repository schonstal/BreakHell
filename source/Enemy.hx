package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;

class Enemy extends Actor {
  public static var ROW_HEIGHT:Int = 12;
  public static var COLUMN_WIDTH:Int = 30;

  var startingHealth:Int = 0;

  public function new() {
    super();
    immovable = true;

    startingHealth = Reg.random.int(1, 4);
    health = startingHealth;
    points = Std.int(startingHealth * 50);

    loadGraphic("assets/images/enemy/enemy.png", true, 28, 10);
    var animationOffset:Int = 8 * (startingHealth - 1);
    animation.add(
      "idle",
      [0 + animationOffset, 1 + animationOffset, 2 + animationOffset, 3 + animationOffset],
      15
    );
    animation.add(
      "damaged",
      [4 + animationOffset, 5 + animationOffset, 6 + animationOffset, 7 + animationOffset],
      15
    );

    velocity.y = 10;
  }

  public override function update(elapsed:Float):Void {
    if (health > 1 || startingHealth == 1) {
      animation.play("idle");
    } else {
      animation.play("damaged");
    }
    super.update(elapsed);
  }

  public function initialize(column:Int):Void {
    y = Reg.spawnRow * -ROW_HEIGHT;
    x = column * COLUMN_WIDTH + 41;
  }
}
