import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flash.geom.Point;
import flixel.system.FlxSound;
import flixel.math.FlxRandom;
import flixel.math.FlxVector;
import flixel.group.FlxSpriteGroup;

class Health extends Powerup {
  var initialized:Bool = false;

  public function new() {
    super();
    name = "health";
  }

  public override function onPickup():Void {
    Reg.player.health += 50;
    if (Reg.player.health >= 100) {
      Reg.player.health = 100;
    }

    FlxG.camera.flash(0xccffffff, 0.5, null, true);
    // FlxG.sound.play("assets/sounds/player/heal.wav", 0.5 * FlxG.save.data.sfxVolume);

    kill();
  }
}
