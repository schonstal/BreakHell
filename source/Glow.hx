package;

import flixel.FlxSprite;
import flixel.FlxG;
import flash.display.BlendMode;

class Glow extends FlxSprite {
  var sinAmt:Float = 0;

  public function new() {
    super();
    loadGraphic("assets/images/background/glow.png");
    blend = BlendMode.ADD;
    alpha = 0.2;
  }

  public override function update(elapsed:Float):Void {
    sinAmt += 2 * elapsed;
    alpha = 0.2 + (0.05 * Math.sin(sinAmt));
    super.update(elapsed);
  }
}
