package;

import flixel.FlxG;
import flixel.FlxSprite;

class PlayerRail extends FlxSprite
{
  public function new(X:Float=0, Y:Float=0) {
    super(X, Y);
    loadGraphic("assets/images/player/player_rail.png");
  }

  public override function update(elapsed:Float):Void {
    y = FlxG.height - 30;

    super.update(elapsed);
  }
}
