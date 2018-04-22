package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flash.geom.Point;
import flixel.system.FlxSound;
import flixel.math.FlxRandom;
import flixel.math.FlxVector;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxTimer;
import flixel.util.FlxSpriteUtil;

class Player extends Actor
{
  public static var RUN_SPEED:Float = 150;
  public static var DECELERATION:Float = 2000;

  public var justHurt:Bool = false;

  var terminalVelocity:Float = 200;

  var shootTimer:Float = 0;
  var shootRate:Float = 0.1;

  var elapsed:Float = 0;

  public function new(X:Float=0,Y:Float=0) {
    super();
    x = X;
    y = Y;
    loadGraphic("assets/images/player/player.png", true, 12, 12);

    width = 5;
    height = 8;

    offset.y = 1;
    offset.x = 3;

    maxVelocity.x = RUN_SPEED;
    maxVelocity.y = RUN_SPEED;

    setFacingFlip(FlxObject.LEFT, true, false);
    setFacingFlip(FlxObject.RIGHT, false, false);

    start();
  }

  public function init():Void {
    Reg.player = this;

    velocity.x = velocity.y = 0;
    acceleration.x = 0;

    facing = FlxObject.RIGHT;
    acceleration.y = 0;
    health = 100;
  }

  private function start():Void {
    Reg.started = true;
    visible = true;
    solid = true;
    alive = true;
  }

  public override function hurt(damage:Float):Void {
    if(justHurt && damage < 100) return;

    //FlxG.camera.flash(0xccff1472, 0.5, null, true);
    FlxG.camera.shake(0.005, 0.2);

    justHurt = true;
    FlxSpriteUtil.flicker(this, 0.6, 0.04, true, true, function(flicker) {
      justHurt = false;
    });
    //FlxG.sound.play("assets/sounds/player/hurt.wav", 1 * FlxG.save.data.sfxVolume);

    super.hurt(damage);
  }

  private function xMovement():Void {
    if(pressed("left")) {
      velocity.x = -RUN_SPEED;
      facing = FlxObject.LEFT;
    } else if(pressed("right")) {
      velocity.x = RUN_SPEED;
      facing = FlxObject.RIGHT;
    } else if (Math.abs(velocity.x) < 10) {
      velocity.x = 0;
      acceleration.x = 0;
    } else if (velocity.x > 0) {
      acceleration.x = -DECELERATION;
    } else if (velocity.x < 0) {
      acceleration.x = DECELERATION;
    }
  }

  private function yMovement():Void {
    if(pressed("up")) {
      acceleration.y = 0;
      velocity.y = -RUN_SPEED;
    } else if(pressed("down")) {
      acceleration.y = 0;
      velocity.y = RUN_SPEED;
    } else if (Math.abs(velocity.y) < 10) {
      acceleration.y = 0;
      velocity.y = 0;
    } else if (velocity.y > 0) {
      acceleration.y = -DECELERATION;
    } else if (velocity.y < 0) {
      acceleration.y = DECELERATION;
    }
  }

  private function shoot():Void {
    var direction:FlxVector = null;

    if (shootTimer <= 0) {
      direction = new FlxVector(
        FlxG.mouse.x - getMidpoint().x,
        FlxG.mouse.y - getMidpoint().y
      ).normalize();

      Reg.playerProjectileService.shoot(x + (facing == FlxObject.LEFT ? -8 : 8), y + 3, direction, facing);
      shootTimer = shootRate;
      //FlxG.sound.play("assets/sounds/player/shoot.wav", 1 * FlxG.save.data.sfxVolume);
    }
  }

  override public function update(elapsed:Float):Void {
    this.elapsed = elapsed;

    if(alive && Reg.started) {
      xMovement();
      //yMovement();
      if(pressed("shoot")) {
        shoot();
      }
      updateTimers();
    }

    super.update(elapsed);

    if (x < 40) x = 40;
    if (x > FlxG.width - 40 - width) x = FlxG.width - width - 40;
  }

  public override function kill():Void {
    visible = false;
    alive = false;
    Reg.started = false;
    solid = false;
    exists = false;
    acceleration.y = acceleration.x = velocity.x = velocity.y = 0;
    Reg.enemyExplosionService.explode(x + width/2, y + height/2 + explosionOffset.y, 0, 0, true);
    //FlxG.sound.play("assets/sounds/player/die.wav", 1 * FlxG.save.data.sfxVolume);
  }

  private function updateTimers():Void {
    shootTimer -= elapsed;
  }

  private function justPressed(action:String):Bool {
    if (action == "left") {
      return FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A;
    }

    if (action == "right") {
      return FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D;
    }

    if (action == "up") {
      return FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W;
    }

    if (action == "down") {
      return FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S;
    }

    if (action == "direction") {
      return justPressed("left") || justPressed("right");
    }

    if (action == "shoot") {
      return FlxG.keys.justPressed.SPACE || FlxG.mouse.justPressed;
    }
    return false;
  }

  private function pressed(action:String):Bool {
    if (action == "left") {
      return FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A;
    }

    if (action == "right") {
      return FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D;
    }

    if (action == "up") {
      return FlxG.keys.pressed.UP || FlxG.keys.pressed.W;
    }

    if (action == "down") {
      return FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S;
    }

    if (action == "direction") {
      return pressed("left") || justPressed("right");
    }

    if (action == "shoot") {
      return FlxG.keys.pressed.SPACE || FlxG.mouse.pressed;
    }
    return false;
  }
}
