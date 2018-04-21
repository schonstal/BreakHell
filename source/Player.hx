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

class Player extends Enemy
{
  public static var RUN_SPEED:Float = 200;
  public static var gravity:Float = 800;

  public var justHurt:Bool = false;

  var speed:Point;
  var terminalVelocity:Float = 200;

  var shootTimer:Float = 0;
  var shootRate:Float = 0.035;

  var elapsed:Float = 0;

  public function new(X:Float=0,Y:Float=0) {
    super();
    x = X;
    y = Y;
    loadGraphic("assets/images/player/player.png", true, 12, 12);

    visible = false;

    width = 5;
    height = 8;

    offset.y = 1;
    offset.x = 3;

    speed = new Point();
    speed.y = jumpAmount;
    speed.x = 800;
    solid = false;

    maxVelocity.x = RUN_SPEED;

    setFacingFlip(FlxObject.LEFT, true, false);
    setFacingFlip(FlxObject.RIGHT, false, false);
  }

  public function init():Void {
    Reg.player = this;
    jumpPressed = false;

    jumpTimer = 0;

    velocity.x = velocity.y = 0;
    acceleration.x = 0;

    facing = FlxObject.RIGHT;
    acceleration.y = 0;
    Reg.started = false;
    health = 100;
  }

  private function start():Void {
    acceleration.y = gravity;
    visible = true;
    solid = true;
    alive = true;
    Reg.started = true;
  }

  public override function hurt(damage:Float):Void {
    if(justHurt && damage < 100) return;

    FlxG.camera.flash(0xccff1472, 0.5, null, true);
    FlxG.camera.shake(0.005, 0.2);

    justHurt = true;
    FlxSpriteUtil.flicker(this, 0.6, 0.04, true, true, function(flicker) {
      justHurt = false;
    });
    //FlxG.sound.play("assets/sounds/player/hurt.wav", 1 * FlxG.save.data.sfxVolume);

    super.hurt(damage);
  }

  private function handleMovement():Void {
    if(pressed("left")) {
      acceleration.x = -speed.x * (velocity.x > 0 ? 4 : 1);
      facing = FlxObject.LEFT;
      shoot();
    } else if(pressed("right")) {
      acceleration.x = speed.x * (velocity.x < 0 ? 4 : 1);
      facing = FlxObject.RIGHT;
      shoot();
    } else if (Math.abs(velocity.x) < 10) {
      velocity.x = 0;
      acceleration.x = 0;
    } else if (velocity.x > 0) {
      acceleration.x = -speed.x * 2;
    } else if (velocity.x < 0) {
      acceleration.x = speed.x * 2;
    }

    if (x < 0) x = 0;
    if (x > FlxG.width - width) x = FlxG.width - width;
    if (y < 0) y = 0;
    if (y > FlxG.height - height) y = FlxG.height - height;
  }

  private function shoot():Void {
    if (shootTimer <= 0) {
      var direction = new FlxVector(facing == FlxObject.LEFT ? 1 : -1, Reg.random.float(-0.05, 0.05));
      Reg.playerProjectileService.shoot(x + (facing == FlxObject.LEFT ? 8 : -8), y + 3, direction, facing);
      shootTimer = shootRate;
      //FlxG.sound.play("assets/sounds/player/shoot.wav", 1 * FlxG.save.data.sfxVolume);
    }
  }

  override public function update(elapsed:Float):Void {
    this.elapsed = elapsed;

    if(alive && Reg.started) {
      handleMovement();
      updateTimers();
    }

    super.update(elapsed);
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
    if (action == (FlxG.save.data.invertControls ? "left" : "right")) {
      return FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A;
    }
    if (action == (FlxG.save.data.invertControls ? "right" : "left")) {
      return FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D;
    }
    if (action == "direction") {
      return justPressed("left") || justPressed("right");
    }
    return false;
  }

  private function pressed(action:String):Bool {
    if (action == "jump") {
      return FlxG.keys.pressed.S || FlxG.keys.pressed.DOWN || FlxG.keys.pressed.W ||
             FlxG.keys.pressed.UP || FlxG.keys.pressed.SPACE;
    }
    if (action == (FlxG.save.data.invertControls ? "left" : "right")) {
      return FlxG.keys.pressed.LEFT || FlxG.keys.justPressed.A;
    }
    if (action == (FlxG.save.data.invertControls ? "right" : "left")) {
      return FlxG.keys.pressed.RIGHT || FlxG.keys.justPressed.D;
    }
    if (action == "direction") {
      return pressed("left") || justPressed("right");
    }
    return false;
  }
}