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
    Reg.spawnRow++;
    spawnRow();
    Reg.spawnRow++;
    spawnRow();
    Reg.spawnRow++;
    spawnRow();
    Reg.spawnRow++;
    spawnRow();
    Reg.spawnRow++;
    spawnRow();
    Reg.spawnRow++;
    spawnRow();
    Reg.spawnRow++;
    spawnRow();
    Reg.spawnRow++;
    spawnRow();
    Reg.spawnRow++;
    spawnRow();
    Reg.spawnRow++;
  }

  function spawnRow():Void {
    var column:Int;
    for (column in 0...Std.int(FlxG.width / Enemy.COLUMN_WIDTH)) {
      var e:Enemy = cast(recycle(Enemy), Enemy);
      e.spawn();
      e.initialize(column);
      add(e);
    }
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
  }
}
