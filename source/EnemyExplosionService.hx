package;

import flixel.group.FlxSpriteGroup;
import flixel.math.FlxVector;
import flixel.FlxObject;

class EnemyExplosionService {
  var enemyExplosions:Array<EnemyExplosion> = new Array<EnemyExplosion>();
  var group:FlxSpriteGroup;

  public function new(group:FlxSpriteGroup):Void {
    this.enemyExplosions = new Array<EnemyExplosion>();
    this.group = group;
  }

  public function explode(X:Float, Y:Float, width:Float = 0, height:Float = 0, actor:Actor):EnemyExplosion {
    var x = X + Reg.random.float(0, width);
    var y = Y + Reg.random.float(0, height);

    var enemyExplosion = recycle(x, y, actor);
    group.add(enemyExplosion);
    enemyExplosion.explode();

    return enemyExplosion;
  }

  function recycle(X:Float, Y:Float, actor:Actor):EnemyExplosion {
    for(p in enemyExplosions) {
      if(!p.exists) {
        p.initialize(X, Y, actor);
        return p;
      }
    }

    var enemyExplosion:EnemyExplosion = new EnemyExplosion();
    enemyExplosion.initialize(X, Y, actor);
    enemyExplosions.push(enemyExplosion);

    return enemyExplosion;
  }
}
