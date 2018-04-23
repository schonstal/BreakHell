package;

import flixel.group.FlxGroup;
import flixel.math.FlxVector;
import flixel.FlxObject;

class PowerupService {
  var powerups:Array<PowerupGroup> = new Array<PowerupGroup>();
  var group:FlxGroup;
  var showParticles:Bool;
  var name:String;
  var activeUpgradePowerup:Powerup;

  public function new(group:FlxGroup, name:String = "player", showParticles:Bool = false):Void {
    this.powerups = new Array<PowerupGroup>();
    this.group = group;
    this.showParticles = showParticles;
    this.name = name;
  }

  public function spawn(name:String, X:Float, row:Int):PowerupGroup {
    var powerup = recycle(name, X, row);
    group.add(powerup);

    return powerup;
  }

  function recycle(name:String, X:Float, row:Int):PowerupGroup {
    for(p in powerups) {
      if(!p.exists) {
        p.spawn(name, X, row);
        return p;
      }
    }

    var powerup:PowerupGroup = new PowerupGroup();
    powerup.spawn(name, X, row);
    powerups.push(powerup);

    return powerup;
  }
}
