package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxObject;
import flixel.util.FlxColor;

import flixel.math.FlxVector;
import flixel.math.FlxMath;

class PowerupGroup extends FlxSpriteGroup {
  var particles:FlxSpriteGroup;
  var powerupSprite:Powerup;

  var particleTimer:Float = 0;
  var particleThreshold:Float = 0.025;

  var name:String = "health";

  public function new() {
    super();
    particles = new FlxSpriteGroup();
    add(particles);
  }

  public function spawn(name:String, X:Float, row:Int) {
    this.name = name;

    powerupSprite = cast(recycle(Powerup), Powerup);
    powerupSprite.spawn(name, X, row);
    add(powerupSprite);
  }

  override public function update(elapsed:Float):Void {
    if(powerupSprite != null && powerupSprite.exists) {
      spawnParticles(elapsed);
    }

    super.update(elapsed);
  }

  function spawnParticles(elapsed:Float) {
    particleTimer += elapsed;
    if (particleTimer >= particleThreshold) {
      var particle:FlxSprite = particles.recycle(FlxSprite);
      var size = Reg.random.int(0, 2);

      particle.loadGraphic('assets/images/powerups/$name/particle.png', true, 5, 5);
      particle.animation.add("0", [0]);
      particle.animation.add("1", [0]);
      particle.animation.add("2", [1]);
      particle.animation.play('$size');

      particle.x = powerupSprite.x + Reg.random.int(1, 9);
      particle.y = powerupSprite.y;

      particle.velocity.x = Reg.random.int(-10, 10);
      particle.velocity.y = Reg.random.int(-10, 0);

      particle.exists = true;
      particle.visible = true;
      particle.solid = false;

      new FlxTimer().start(Reg.random.float(0.3, 0.6), function(t) {
        particle.exists = false;
      });

      particleTimer = 0;
    }
  }
}
