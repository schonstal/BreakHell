
package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.math.FlxPoint;

class GameOverGroup extends FlxSpriteGroup {
  var gameOverSprite:FlxSprite;
  var scoreText:FlxBitmapText;
  var highScoreText:FlxBitmapText;

  public function new():Void {
    super();

    var font = FlxBitmapFont.fromMonospace(
      "assets/images/fonts/numbers2x.png",
      "0123456789",
      new FlxPoint(16, 16)
    );

    gameOverSprite = new FlxSprite();
    gameOverSprite.loadGraphic("assets/images/hud/gameOver.png");
    add(gameOverSprite);

    scoreText = new FlxBitmapText(font);
    scoreText.letterSpacing = -2;
    scoreText.text = "0";
    scoreText.x = 4;
    scoreText.y = FlxG.height / 2 + 16;
    add(scoreText);

    highScoreText = new FlxBitmapText(font);
    highScoreText.letterSpacing = -2;
    highScoreText.text = "0";
    highScoreText.x = FlxG.width / 2 - 8;
    highScoreText.y = FlxG.height / 2 + 16;
    add(highScoreText);

    exists = false;
  }

  public override function update(elapsed:Float):Void {
    scoreText.text = "" + Reg.score;
    highScoreText.text = "" + FlxG.save.data.highScore;

    scoreText.x = FlxG.width / 2 - scoreText.width - 16;
    highScoreText.x = FlxG.width / 2 + 16;

    super.update(elapsed);
  }
}
