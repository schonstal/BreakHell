package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;

class Enemy extends Actor {
  public static var ROW_HEIGHT:Int = 12;
  public static var COLUMN_WIDTH:Int = 30;
  public static var SPEED:Int = 10;
  public static var probabilities:Array<Int> = [
    1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4
  ];

  var row:Int = 0;
  var onFall:Int->Void;

  public function new() {
    super();
    immovable = true;

    var healthRange = Reg.random.int(0, probabilities.length - 1);
    startingHealth = probabilities[healthRange];

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
  }

  public override function hurt(amount:Float) {
    super.hurt(amount);

    var pitch:Int = Reg.random.int(0, 2);
    Reg.hitSound = FlxG.sound.play('assets/sounds/enemy/hit$pitch.ogg', 0.4);
  }

  public override function update(elapsed:Float):Void {
    if (health > 1 || startingHealth == 1) {
      animation.play("idle");
    } else {
      animation.play("damaged");
    }

    if (y >= FlxG.height) {
      points = 0;
      kill();
      if (onFall != null) {
        onFall(row);
      }
    }

    super.update(elapsed);

    y = Reg.scrollPosition - (row * ROW_HEIGHT);
  }

  public function initialize(column:Int, ?onFall:Int->Void):Void {
    y = Reg.spawnRow * -ROW_HEIGHT;
    x = column * COLUMN_WIDTH + 41;
    row = Reg.spawnRow;
    alive = true;
    exists = true;
    health = startingHealth;
    this.onFall = onFall;
  }

  override function die():Void {
    super.die();

    var pitch:Int = Reg.random.int(0, 2);
    if (Reg.player.alive) {
      if (Reg.explosionSound != null) {
        Reg.explosionSound.stop();
      }
      Reg.explosionSound = FlxG.sound.play('assets/sounds/enemy/destroy20.ogg', 0.3);
    }

    var powerupValue:Int = Reg.random.int(0, 200);

    if (powerupValue < 4) {
      Reg.powerupService.spawn("health", getMidpoint().x, row);
    }

    if (startingHealth > 2 && powerupValue > 199) {
      if (Reg.player.shootRate > 0.06) {
        Reg.powerupService.spawn("upgrade", getMidpoint().x, row);
      } else {
        Reg.powerupService.spawn("health", getMidpoint().x, row);
      }
    }
  }
}
