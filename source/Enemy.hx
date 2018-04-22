package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;

class Enemy extends Actor {
  public static var ROW_HEIGHT:Int = 10;
  public static var COLUMN_WIDTH:Int = 30;

  public function new() {
    super();
    immovable = true;

    health = Reg.random.int(1, 4);
    points = Std.int(health * 50);

    makeGraphic(COLUMN_WIDTH - 2, ROW_HEIGHT - 2, 0xffffffff);

    velocity.y = 10;
  }

  public override function update(elapsed:Float):Void {
    super.update(elapsed);

    switch(health) {
      case 1:
        color = 0xff66ff66;
      case 2:
        color = 0xff6666ff;
      case 3:
        color = 0xffff66ff;
      case 4:
        color = 0xffff6666;
    }

  }

  public function initialize(column:Int):Void {
    y = Reg.spawnRow * -ROW_HEIGHT;
    x = column * COLUMN_WIDTH;
  }
}
