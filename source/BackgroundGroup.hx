package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxObject;

import flixel.math.FlxVector;
import flixel.math.FlxMath;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class BackgroundGroup extends FlxSpriteGroup {
  var activeRow = -10;

  public function new() {
    super();

    var i:Int;
    for (i in (0...10)) {
      spawnRow();
    }
  }

  function spawnRow():Void {
    var bg:BackgroundSprite = cast(recycle(BackgroundSprite), BackgroundSprite);
    bg.initialize(0, activeRow);
    add(bg);

    bg = cast(recycle(BackgroundSprite), BackgroundSprite);
    bg.initialize(1, activeRow);
    add(bg);

    activeRow++;
  }

  override public function update(elapsed:Float):Void {
    if (Reg.scrollPosition > activeRow * Enemy.SPEED - 100) {
      spawnRow();
    }

    super.update(elapsed);
  }
}
