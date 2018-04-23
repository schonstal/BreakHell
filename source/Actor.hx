package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import flixel.addons.display.FlxNestedSprite;

import flash.geom.ColorTransform;

class Actor extends FlxNestedSprite {
  // GAME JAM!
  public var startingHealth:Int = 100;
  public var points:Int = 0;

  var flashTimer:FlxTimer;
  var explosionTimer:FlxTimer;
  var explosionRate:Float = 0.2;
  var deathTimer:FlxTimer;

  var deathTime:Float = 0;
  var deathWidth:Float = 0;
  var deathHeight:Float = 0;

  var explosionOffset:FlxPoint;
  var explosionCount:Int = 1;

  public var onDeath:Void->Void;

  public function new() {
    super();
    health = startingHealth;
    flashTimer = new FlxTimer();
    explosionTimer = new FlxTimer();
    deathTimer = new FlxTimer();
    explosionOffset = new FlxPoint(0, 0);
  }

  public override function hurt(damage:Float):Void {
    if (!alive) return;

    super.hurt(damage);
    flash();
    //FlxG.sound.play("assets/sounds/enemyHurt.wav", 0.7 * FlxG.save.data.sfxVolume);
  }

  public override function kill():Void {
    setColorTransform();
    color = 0xff8c4a53;
    alive = false;

    if (points > 0) {
      Reg.score += points;
      Reg.pointService.showPoints(x + width/2, y + height/2, points);
    }

    blowUp();
    die();
    //FlxG.sound.play("assets/sounds/enemyDie.wav", 1 * FlxG.save.data.sfxVolume);
  }

  function blowUp():Void {
    FlxG.camera.shake(0.005, 0.2);
    for(i in 0...explosionCount) {
      Reg.enemyExplosionService.explode(x + width/2 + explosionOffset.x,
                                        y + height/2 + explosionOffset.y,
                                        deathWidth, deathHeight, this);
    }
  }

  function die():Void {
    exists = false;
    if (onDeath != null) onDeath();
  }

  public function flash():Void {
    useColorTransform = true;
    setColorTransform(0, 0, 0, 1, 0, 0, 0, 0);

    flashTimer.start(0.025, function(t) {
      setColorTransform(0, 0, 0, 1, 255, 255, 255, 0);

      flashTimer.start(0.025, function(t) {
        setColorTransform();
      });
    });
  }

  public function spawn():Void {
    alive = true;
    exists = true;
    setColorTransform();
  }

  public function onStart():Void {
  };
}
