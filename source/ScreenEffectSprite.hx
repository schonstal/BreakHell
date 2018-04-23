package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class ScreenEffectSprite extends FlxSprite {
  var fadeDuration:Float = 0;
  var fadeCompleted:Bool = true;
  var fadeComplete:Void->Void;
  var fadeIn:Bool = false;
  var fadeColor:FlxColor = FlxColor.BLACK;

  public function new() {
    super();

    makeGraphic(FlxG.width, FlxG.height, 0xffffffff);
    alpha = 0;
  }

  public override function update(elapsed:Float):Void {
    super.update(elapsed);

    updateFade(elapsed);
  }

  public function fade(
    color:FlxColor = FlxColor.BLACK,
    duration:Float = 1,
    fadeIn:Bool = false,
    ?onComplete:Void->Void,
    force:Bool = false
  ):Void {
    if (!fadeCompleted && !force) {
      return;
    }

    this.color = color;
    if (duration <= 0) {
      duration = 0.000001;
    }

    this.fadeIn = fadeIn;
    fadeDuration = duration;
    fadeComplete = onComplete;

    alpha = fadeIn ? 0.999999 : 0.000001;
    fadeCompleted = false;
  }


  public function flash(
    color:FlxColor = FlxColor.WHITE,
    duration:Float = 1,
    ?onComplete:Void->Void,
    force:Bool = false
  ):Void {
    fade(color, duration, true, onComplete, force);
  }

  function updateFade(elapsed:Float):Void {
    if (fadeCompleted) {
      return;
    }

    if (fadeIn) {
      alpha -= elapsed / fadeDuration;

      if (alpha <= 0.0) {
        alpha = 0.0;
        completeFade();
      }
    } else {
      alpha += elapsed / fadeDuration;

      if (alpha >= 1.0) {
        alpha = 1.0;
        completeFade();
      }
    }
  }

  private function completeFade() {
    fadeCompleted = true;
    if (fadeComplete != null) {
      fadeComplete();
    }
  }
}
