import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flash.geom.Point;
import flixel.system.FlxSound;
import flixel.math.FlxRandom;
import flixel.math.FlxVector;
import flixel.group.FlxSpriteGroup;

class Powerup extends FlxSprite {
  var initialized:Bool = false;
  var name:String = "health";
  var row:Int = 0;

  public function new() {
    super();
  }

  public function spawn(recycledName:String, X:Float, row:Int):Void {
    name = recycledName;

    if (!initialized) {
      loadGraphic('assets/images/powerups/$name/pickup.png', true, 12, 12);
      animation.add("flash", [0, 1], 10, true);
      animation.play("flash");
    }

    x = X - width / 2;
    this.row = row;

    initialized = true;
    alive = true;
    exists = true;
    //velocity.y = 100;
  }

  public override function update(elapsed:Float):Void {
    if (y > FlxG.height) exists = false;

    super.update(elapsed);

    y = Reg.scrollPosition - (row * Enemy.ROW_HEIGHT) - (height - Enemy.ROW_HEIGHT) / 2;
  }

  public function onPickup():Void {
    if (name == "health") {
      onPickupHealth();
    }

    if (name == "upgrade") {
      onPickupUpgrade();
    }

    kill();
  }

  function onPickupHealth():Void {
    Reg.player.health += 25;
    if (Reg.player.health >= 100) {
      Reg.player.health = 100;
    }

    Reg.screenEffect.flash(0xccffffff, 0.5, null, true);
    FlxG.sound.play("assets/sounds/health.ogg", 0.6);
  }

  function onPickupUpgrade():Void {
    Reg.player.shootRate *= 0.9;
    if (Reg.player.shootRate <= 0.7) {
      Reg.player.shootRate = 0.7;
    }

    Reg.screenEffect.flash(0xccffffff, 0.5, null, true);
    FlxG.sound.play("assets/sounds/health.ogg", 0.6);
  }
}
