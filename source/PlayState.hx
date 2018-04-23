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
  var playerRail:PlayerRail;
  var enemyGroup:EnemyGroup;
  var pointGroup:FlxSpriteGroup;
  var enemyExplosionGroup:FlxSpriteGroup;
  var wallGroup:FlxSpriteGroup;
  var gameOverGroup:GameOverGroup;

  var backgroundGroup:BackgroundGroup;

  override public function create():Void {
    super.create();
    Reg.random = new FlxRandom();
    Reg.started = false;
    Reg.score = 0;
    Reg.spawnRow = 0;
    Reg.scrollPosition = 0;

    bgColor = 0xff62acda;

    playerProjectileGroup = new FlxSpriteGroup();
    enemyExplosionGroup = new FlxSpriteGroup();
    enemyGroup = new EnemyGroup();
    pointGroup = new FlxSpriteGroup();
    gameOverGroup = new GameOverGroup();
    wallGroup = new FlxSpriteGroup();
    backgroundGroup = new BackgroundGroup();

    Reg.leftWall = new FlxSprite();
    Reg.leftWall.makeGraphic(40, FlxG.height, 0xff666666);
    Reg.leftWall.immovable = true;
    wallGroup.add(Reg.leftWall);

    Reg.rightWall = new FlxSprite();
    Reg.rightWall.makeGraphic(40, FlxG.height, 0xff666666);
    Reg.rightWall.immovable = true;
    Reg.rightWall.x = FlxG.width - Reg.rightWall.width;
    wallGroup.add(Reg.rightWall);

    Reg.pointService = new PointService(pointGroup);
    Reg.playerProjectileService = new ProjectileService(playerProjectileGroup);
    Reg.enemyExplosionService = new EnemyExplosionService(enemyExplosionGroup);

    player = new Player();
    player.init();
    player.y = FlxG.height - 40;
    player.x = FlxG.width / 2 - player.width / 2;

    playerRail = new PlayerRail();

    FlxG.debugger.drawDebug = true;
    FlxG.debugger.visible = true;

    add(backgroundGroup);
    add(enemyGroup);
    add(playerRail);
    add(playerProjectileGroup);
    add(player);
    add(wallGroup);
    add(enemyExplosionGroup);
    add(pointGroup);
    add(gameOverGroup);
  }

  override public function destroy():Void {
    super.destroy();
  }

  override public function update(elapsed:Float):Void {
    FlxG.collide(wallGroup, playerProjectileGroup, function(wall:FlxObject, projectile:FlxObject):Void {
      Projectile.handleCollision(wall, projectile);
    });

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

    if (FlxG.keys.justPressed.SPACE && !player.alive) {
      FlxG.switchState(new PlayState());
    }

    if (FlxG.save.data.highScore == null || Reg.score > FlxG.save.data.highScore) {
      FlxG.save.data.highScore = Reg.score;
    }

    super.update(elapsed);

    if (!player.alive) {
      gameOverGroup.visible = true;
    }
  }
}
