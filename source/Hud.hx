package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.math.FlxPoint;

class Hud extends FlxSpriteGroup {
  public static var HEALTH_COLOR:Int = 0xffe8c745;

  var scoreLabel:FlxSprite;
  var scoreText:FlxBitmapText;

  var healthLabel:FlxSprite;

  var healthBarBackground:FlxSprite;
  var healthBar:FlxSprite;

  var previousHealth:Float = 0;

  public function new():Void {
    super();

    var font = FlxBitmapFont.fromMonospace(
      "assets/images/fonts/numbers.png",
      "0123456789",
      new FlxPoint(8, 8)
    );

    scoreLabel = new FlxSprite(4, 2);
    scoreLabel.loadGraphic("assets/images/hud/score.png");
    //add(scoreLabel);

    healthLabel = new FlxSprite(0, 2);
    healthLabel.loadGraphic("assets/images/hud/health.png");
    healthLabel.x = FlxG.width - 4 - healthLabel.width;
    //add(healthLabel);

    healthBarBackground = new FlxSprite(0, FlxG.height - 30);
    healthBarBackground.loadGraphic("assets/images/hud/healthBar.png");
    add(healthBarBackground); 

    healthBar = new FlxSprite(healthBarBackground.x + 2, healthBarBackground.y + 4);
    healthBar.makeGraphic(Std.int(healthBarBackground.width) - 8,
                          Std.int(healthBarBackground.height) - 9,
                          HEALTH_COLOR);
    add(healthBar);

    scoreText = new FlxBitmapText(font);
    scoreText.letterSpacing = -1;
    scoreText.text = "0";
    scoreText.x = 40;
    scoreText.y = healthBarBackground.y + 8;
    add(scoreText);
  }

  public override function update(elapsed:Float):Void {
    scoreText.text = "" + Reg.score;

    var width:Int = Std.int((healthBarBackground.width - 4) * Reg.player.health/100);
    if (Reg.player.health != previousHealth && width > 0) {
      healthBar.makeGraphic(width, Std.int(healthBar.height), HEALTH_COLOR);
    } else if (width <= 0) {
      healthBar.visible = false;
    }
    previousHealth = Reg.player.health;
    super.update(elapsed);
  }
}
