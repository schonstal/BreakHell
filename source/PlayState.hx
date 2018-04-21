package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.math.FlxPoint;

class PlayState extends FlxState
{
  var playerProjectileGroup:FlxSpriteGroup;
  var enemyProjectileGroup:FlxSpriteGroup;

  override public function create():Void {
    super.create();
    Reg.random = new FlxRandom();
    Reg.started = false;
    Reg.score = 0;

    playerProjectileGroup = new FlxSpriteGroup();
    Reg.playerProjectileService = new ProjectileService(playerProjectileGroup);

    enemyProjectileGroup = new FlxSpriteGroup();
    Reg.enemyProjectileService = new ProjectileService(enemyProjectileGroup, "enemy");

    FlxG.debugger.drawDebug = true;
  }

  override public function destroy():Void {
    super.destroy();
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
  }
}
