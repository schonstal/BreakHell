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
    // It's not a game jam without a terrible hack
    } else if (other != Reg.rightWall && other != Reg.leftWall) {
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
  }

  public function isDangerous():Bool {
    return dangerous;
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
  }
}
