package;

import flixel.FlxG;
import flixel.FlxSprite;

class Reticle extends FlxSprite
{
  var usable:Bool = true;

  public function new() {
    super();

    loadGraphic("assets/images/hud/reticle.png", true, 16, 16);
    animation.add("default", [0,0,1,2,3,4,4,5,6,7], 10, true);
    animation.play("default");

    activate();
  }

  public function activate():Void {
    usable = true;
  }

  public function deactivate():Void {
    usable = false;
  }

  public override function update(elapsed:Float):Void {
    super.update(elapsed);

    if(usable) {
      alpha = 1;
    } else {
      alpha = 0.5;
    }

    x = FlxG.mouse.x - width/2 + 1;
    y = FlxG.mouse.y - height/2 + 1;
  }
}
