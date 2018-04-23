package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;

class BackgroundSprite extends FlxSprite {
  var row:Int = 0;

  public function new() {
    super();
    loadGraphic("assets/images/background/conveyors.png");
  }

  public override function update(elapsed:Float):Void {
    y = Reg.scrollPosition - (row * height);

    if (y > FlxG.height) {
      exists = false;
      alive = false;
    }

    super.update(elapsed);
  }

  public function initialize(column:Int, spawnRow:Int):Void {
    row = spawnRow;

    y = row * -height;
    x = column * width + 40;
    alive = true;
    exists = true;
  }
}
