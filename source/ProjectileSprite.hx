package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;

class ProjectileSprite extends FlxSprite {
  var WIDTH = 6;
  var HEIGHT = 6;
  var name:String;
  var dangerous:Bool = false;

  public var onCollisionCallback:Void->Void;

  public function new(name:String = "player") {
    super();
    this.name = name;
    var size = 32;
    elasticity = 1;

    loadGraphic('assets/images/projectiles/$name/projectiles.png', true, size, size);
    animation.add("pulse", [2, 3], 10);
    animation.add("pulseInvert", [0, 1], 10);
    animation.play("pulse");

    width = WIDTH;
    height = HEIGHT;

    setFacingFlip(FlxObject.LEFT, true, false);
    setFacingFlip(FlxObject.RIGHT, false, false);
  }

  public function onCollide(other:FlxObject):Void {
    if (other == Reg.player) {
      if (onCollisionCallback != null) {
        onCollisionCallback();
      }
    } else {
      dangerous = true;
      animation.play("pulseInvert");
    }
  }

  public function initialize():Void {
    dangerous = false;
    animation.play("pulse");
  }

  override public function updateHitbox():Void
  {
    var newWidth:Float = scale.x * WIDTH;
    var newHeight:Float = scale.y * HEIGHT;

    width = newWidth;
    height = newHeight;
    offset.set(
      -((newWidth - frameWidth) * 0.5),
      -((newHeight - frameHeight) * 0.5)
    );
    centerOrigin();
    if (name == "player") {
      offset.x += (facing == FlxObject.LEFT ? 4 : -4);
    }
  }

  public function isDangerous():Bool {
    return dangerous;
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
  }
}
