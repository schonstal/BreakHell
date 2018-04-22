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
import flixel.addons.display.FlxBackdrop;

class PlayState extends FlxState
{
  var playerProjectileGroup:FlxSpriteGroup;
  var enemyProjectileGroup:FlxSpriteGroup;

  var player:Player;
  var enemyGroup:EnemyGroup;
  var pointGroup:FlxSpriteGroup;
  var enemyExplosionGroup:FlxSpriteGroup;

  override public function create():Void {
    super.create();
    Reg.random = new FlxRandom();
    Reg.started = false;
    Reg.score = 0;

    bgColor = 0xff62acda;

    var background = new FlxBackdrop("assets/images/background.png");
    background.velocity.x = 0;
    background.velocity.y = 10;
    background.scale.x = background.scale.y = 2;
    background.color = 0xffb0d0e5;
    add(background);

    playerProjectileGroup = new FlxSpriteGroup();
    enemyExplosionGroup = new FlxSpriteGroup();
    enemyGroup = new EnemyGroup();
    pointGroup = new FlxSpriteGroup();

    Reg.pointService = new PointService(pointGroup);
    Reg.playerProjectileService = new ProjectileService(playerProjectileGroup);
    Reg.enemyExplosionService = new EnemyExplosionService(enemyExplosionGroup);

    player = new Player();
    player.init();
    player.y = FlxG.height - 20;
    player.x = FlxG.width / 2 - player.width / 2;

    FlxG.mouse.visible = false;

    FlxG.debugger.drawDebug = true;

    add(enemyGroup);
    add(playerProjectileGroup);
    add(enemyExplosionGroup);
    add(pointGroup);
    add(player);
  }

  override public function destroy():Void {
    super.destroy();
  }

  override public function update(elapsed:Float):Void {
    FlxG.collide(enemyGroup, playerProjectileGroup, function(enemy:FlxObject, projectile:FlxObject):Void {
      enemy.hurt(1);
      Projectile.handleCollision(enemy, projectile);
    });

    FlxG.overlap(player, playerProjectileGroup, function(player:FlxObject, projectile:FlxObject):Void {
      if (player.alive && cast(projectile, ProjectileSprite).isDangerous()) {
        player.hurt(25);
        Projectile.handleCollision(player, projectile);
      }
    });

    if (FlxG.keys.justPressed.Q) {
      FlxG.switchState(new PlayState());
    }
    super.update(elapsed);
  }
}
