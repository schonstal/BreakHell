package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxObject;

import flixel.math.FlxVector;
import flixel.math.FlxMath;

class EnemyGroup extends FlxSpriteGroup {
  var spawnTimer:Float = 0;

  public function new() {
    super();
    spawnRow();
  }

  function spawnRow():Void {
    var column:Int;
    for (column in 0...8) {
      var e:Enemy = cast(recycle(Enemy), Enemy);
      e.spawn();
      e.initialize(column);
      add(e);
    }

    Reg.spawnRow++;
  }

  override public function update(elapsed:Float):Void {
    Reg.scrollPosition += Enemy.SPEED * elapsed;

    if (Reg.scrollPosition > Reg.spawnRow * Enemy.SPEED - 100) {
      spawnRow();
    }

    super.update(elapsed);
  }
}
