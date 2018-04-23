package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;
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

  var reticle:Reticle;
  var player:Player;
  var playerRail:PlayerRail;
  var enemyGroup:EnemyGroup;
  var pointGroup:FlxSpriteGroup;
  var enemyExplosionGroup:FlxSpriteGroup;
  var wallGroup:FlxSpriteGroup;
  var gameOverGroup:GameOverGroup;
  var powerupGroup:FlxGroup;
  var hud:Hud;

  var backgroundGroup:BackgroundGroup;

  var gameOver:Bool = false;

  override public function create():Void {
    super.create();
    Reg.random = new FlxRandom();
    Reg.started = false;
    Reg.score = 0;
    Reg.spawnRow = 0;
    Reg.scrollPosition = 0;

    FlxG.debugger.drawDebug = true;
    FlxG.debugger.visible = true;
    FlxG.mouse.visible = false;

    bgColor = 0xff62acda;

    playerProjectileGroup = new FlxSpriteGroup();
    enemyExplosionGroup = new FlxSpriteGroup();
    enemyGroup = new EnemyGroup();
    pointGroup = new FlxSpriteGroup();
    gameOverGroup = new GameOverGroup();
    wallGroup = new FlxSpriteGroup();
    backgroundGroup = new BackgroundGroup();
    powerupGroup = new FlxGroup();
    hud = new Hud();

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
    Reg.powerupService = new PowerupService(powerupGroup);

    player = new Player();
    player.init();
    player.y = FlxG.height - 30;
    player.x = FlxG.width / 2 - player.width / 2;

    reticle = new Reticle();

    playerRail = new PlayerRail();

    add(backgroundGroup);
    add(enemyGroup);
    add(playerRail);
    add(powerupGroup);
    add(playerProjectileGroup);
    add(player);
    add(wallGroup);
    add(enemyExplosionGroup);
    add(pointGroup);
    add(hud);
    add(reticle);
    add(gameOverGroup);

    if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
      FlxG.sound.playMusic("assets/music/gameplay.ogg", 0.8);
    }
    FlxG.sound.music.volume = 0.8;
  }

  override public function destroy():Void {
    super.destroy();
  }

  override public function update(elapsed:Float):Void {
    FlxG.mouse.visible = false;

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

    FlxG.overlap(player, powerupGroup, function(player:FlxObject, powerup:FlxObject):Void {
      cast(powerup, Powerup).onPickup();
    });

    if (FlxG.keys.justPressed.SPACE && !player.alive) {
      FlxG.switchState(new PlayState());
    }

    if (FlxG.save.data.highScore == null || Reg.score > FlxG.save.data.highScore) {
      FlxG.save.data.highScore = Reg.score;
    }

    super.update(elapsed);

    if (!player.alive) {
      if (!gameOver) {
        FlxG.save.flush();
        FlxG.sound.music.volume = 0.2;
        FlxG.timeScale = 0.2;
        new FlxTimer().start(0.1, function(t) {
          gameOverGroup.exists = true;
          hud.exists = false;
          FlxTween.tween(FlxG, { timeScale: 1 }, 0.5, { ease: FlxEase.quartOut, onComplete: function(t) {
            FlxG.timeScale = 1;
            FlxG.sound.music.volume = 0.8;
          }});
        });
      }
      gameOver = true;
    }
  }
}
