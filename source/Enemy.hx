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

    health = 2;
    points = 100;

    makeGraphic(COLUMN_WIDTH - 2, ROW_HEIGHT - 2, 0xffff00ff);

    velocity.y = 10;
  }

  public function initialize(column:Int):Void {
    y = Reg.spawnRow * -ROW_HEIGHT;
    x = column * COLUMN_WIDTH;
  }
}
