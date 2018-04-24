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
import flixel.system.FlxSound;

class MenuState extends FlxState {
  var reticle:Reticle;
  var playerRail:PlayerRail;
  var wallGroup:FlxSpriteGroup;
  var ceiling:FlxSprite;
  var glow:Glow;
  var backgroundGroup:BackgroundGroup;
  var startSound:FlxSound;
  var scrollTimer:Float = 0;
  var scrollRate:Float = 1;
  var title:FlxSprite;
  var tweenPosition:Int = 0;

  override public function create():Void {
    super.create();
    FlxG.mouse.visible = false;
    FlxG.timeScale = 1;

    wallGroup = new FlxSpriteGroup();
    backgroundGroup = new BackgroundGroup();
    glow = new Glow();

    Reg.leftWall = new FlxSprite();
    Reg.leftWall.loadGraphic("assets/images/background/walls.png", true, 40, FlxG.height);
    Reg.leftWall.immovable = true;
    wallGroup.add(Reg.leftWall);

    Reg.rightWall = new FlxSprite();
    Reg.rightWall.loadGraphic("assets/images/background/walls.png", true, 40, FlxG.height);
    Reg.rightWall.animation.add("idle", [7]);
    Reg.rightWall.animation.play("idle");
    Reg.rightWall.immovable = true;
    Reg.rightWall.x = FlxG.width - Reg.rightWall.width;
    wallGroup.add(Reg.rightWall);

    ceiling = new FlxSprite();
    ceiling.loadGraphic("assets/images/background/ceiling.png");
    ceiling.immovable = true;
    wallGroup.add(ceiling);

    reticle = new Reticle();
    playerRail = new PlayerRail();

    title = new FlxSprite();
    title.loadGraphic("assets/images/title.png");

    add(backgroundGroup);
    add(glow);
    add(playerRail);
    add(wallGroup);
    add(reticle);
    add(title);

    add(Reg.screenEffect);
  }

  override public function destroy():Void {
    super.destroy();
  }

  override public function update(elapsed:Float):Void {
    FlxG.mouse.visible = false;

    scrollTimer += elapsed;
    if (scrollTimer > scrollRate) {
      tweenPosition += 1;
      FlxTween.tween(
        Reg,
        { scrollPosition: Enemy.ROW_HEIGHT * tweenPosition },
        0.25,
        { ease: FlxEase.quadOut }
      );

      scrollTimer = 0;
    }

    if (FlxG.keys.justPressed.SPACE || FlxG.mouse.justPressed) {
      FlxG.switchState(new PlayState());
    }

    super.update(elapsed);
  }
}
