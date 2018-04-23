package;

import flixel.FlxSprite;
import flixel.FlxG;

class EnemyExplosion extends FlxSprite {
  var isPlayer:Null<Bool> = null;

  public function new() {
    super();
    animation.finishCallback = onAnimationComplete;
  }

  public function initialize(X:Float, Y:Float, actor:Actor):Void {
    exists = true;
    x = X;
    y = Y;

    if (actor.startingHealth == 100) {
      loadGraphic("assets/images/player/explosion.png", true, 64, 64);
      offset.x = 32;
      offset.y = 32;
      animation.add("explode", [0, 0, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8], 60, false);
    } else {
      var frames = [0, 1, 2, 3, 4, 5, 6];
      for (i in (0...frames.length)) {
        frames[i] = frames[i] + frames.length * (actor.startingHealth - 1);
      }

      loadGraphic("assets/images/enemy/explosion.png", true, 32, 32);
      offset.x = 16;
      offset.y = 16;
      animation.add("explode", frames, 15, false);
    }
  }

  public function explode():Void {
    animation.play("explode");
  }

  function onAnimationComplete(name:String):Void {
    exists = false;
  }
}
