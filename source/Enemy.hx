package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;

class Enemy extends Actor {
  public static var ROW_HEIGHT:Int = 18;
  public static var COLUMN_WIDTH:Int = 18;

  public function new() {
    super();

    health = 2;
    points = 100;

    makeGraphic(16, 16, 0xffff00ff);

    velocity.y = 10;
  }

  public function initialize(column:Int):Void {
    y = Reg.spawnRow * -ROW_HEIGHT;
    x = column * COLUMN_WIDTH;
  }
}
