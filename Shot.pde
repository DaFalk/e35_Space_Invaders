/*
 MPGD: Exercise 35: Space Invaders
 Jimmie Gustafsson (jgus) & Troels Falkenberg (tfal)
 
This class draws one of multiple shot types and manages it's behaviour, collision and damage depending on type.
 */

class Shot {
  PVector shotPos, shotDir;
  int lastMove, type, owner, damage, lastDmg, nextDmg;
  int points = 2;  //Points awarded for shooting a shot down.
  float shotSize, speed;
  Player player;
  Enemy target;  //For type that requires an enemy target.
  PVector staticTarget;  //Random point target.
  boolean destroy = false;

  Shot(PVector _shotPos, int _type, int _owner) {
    owner = _owner;  //Index determines if the shot belongs to an enemy or a player and which player.
    if (owner < 2) { 
      player = players.get(owner);
    }
    type = _type;
    shotPos = _shotPos;
    lastMove = millis();
    lastDmg = millis();
    nextDmg = 200;
    setShotStats();  //Setup this shot types speed, size and damage.
    getEnemyTarget();  //Try to get an enemy target.
    staticTarget = new PVector(random(shotPos.x - shotSize*20, shotPos.x + shotSize*20), -shotSize);
    audioHandler.playSFX(7+type);  //Shot sounds are indexed next to eachother.
  }

  void update() {
    //Type 3 and 4 requires an enemy target.
    if (type >= 3) {
      //Get a new target if the old target was killed or if the target is none.
      if (target == null) { 
        getEnemyTarget();
      }
      else if (target.isDead) { 
        getEnemyTarget();
      }
    }

    //If unpaused.
    if (!gamePaused) {
      //Add movement to shot as long as it is not type 4 (the beam).
      if (type != 4) {
        shotPos.add(new PVector(timeFix(speed*shotDir.x, lastMove), timeFix(speed*shotDir.y, lastMove)));
        lastMove = millis();
      }
      //Destroy shot if it triggers a collision.
      if (shotCollision() || destroy) { 
        shots.remove(this);
      }
    }
    else { 
      lastMove += millis() - lastMove;
    }  //Adjust lastMove in order to pause shot.

    drawShot();
  }

  //Target new random enemy or remove shot.
  void getEnemyTarget() {
    //Check if there is any enemies alive.
    if (enemies.size() > 0) {
      //Get random enemy target.
      target = enemies.get(floor(random(0, enemies.size())));
      //For type 3 and 4 if target is the boss stop sound and set target to none.
      if ((type == 4 || type == 3) && target == enemyHandler.boss) {
        audioHandler.audioBank[7+type].pause();
        target = null;
      }
    }
    else {
      //For type 3 and 4 remove shot if no enemy is alive.
      if (type == 4 || type == 3) {
        audioHandler.audioBank[7+type].pause();
        shots.remove(this);
      }
    }
  }

  //Draw shot related to the owner's weapon type.
  void drawShot() {
    strokeWeight(dynamicValue(2));
    switch(type) {
      case(0):  //Default shot.
      stroke(255, 255, 255);
      line(shotPos.x, shotPos.y, shotPos.x, shotPos.y + shotSize);
      break;

      case(1):  //Piercer.
      noStroke();
      fill(0, 0, 255);
      triangle(shotPos.x - shotSize/2, shotPos.y, shotPos.x + shotSize/2, shotPos.y - shotSize/2, shotPos.x, shotPos.y + shotSize);
      break;

      case(2):  //Rapid fire
      stroke(126, 126, 126);
      //Calculate angle to static target.
      float angle = atan2(staticTarget.y - shotPos.y, staticTarget.x - shotPos.x);
      shotDir = new PVector(cos(angle), sin(angle));  //Set shot direction.
      line(shotPos.x, shotPos.y, shotPos.x - shotSize*cos(angle), shotPos.y + abs((shotSize)*sin(angle)));
      break;

      case(3):  //Seeker.
      if (target != null) {
        if (!target.isDead) {
          stroke(0, 126, 0);
          noFill();
          ellipse(target.enemyPos.x, target.enemyPos.y, target.eWidth*3, target.eWidth*3);
          //Calculate angle to enemy target.
          float _angle = atan2(target.enemyPos.y - shotPos.y, target.enemyPos.x - shotPos.x);
          shotDir = new PVector(cos(_angle), sin(_angle));  //Update shot direction.
          stroke(126, 0, 0);
          line(shotPos.x, shotPos.y, shotPos.x - shotSize*cos(_angle), shotPos.y + abs((shotSize)*sin(_angle)));
        }
      }
      break;

      case(4):  //Arc beam.
      //Remove shot and stop sound unless there is an enemy target alive, the player can attack and the player weapon type is 4 (charges without a target).
      if (target != null) {
        if (!target.isDead) {
          if (!player.attack || player.weaponType != 4) {
            audioHandler.audioBank[7+type].pause();
            shots.remove(this);
            return;
          }
          noFill();
          stroke(10, 210, 210, random(20, 100));  //Thin-beam flicker.
          strokeWeight(dynamicValue(2.5));
          if (target != null) {
            //Draw a thick bezier curve from player to enemy target.
            bezier(player.x, player.y, player.x, player.y - (height-target.enemyPos.y), target.enemyPos.x, target.enemyPos.y + target.eWidth*2, target.enemyPos.x, target.enemyPos.y);
            stroke(110, 255, 255, random(0, 75));  //Thick-beam flicker.
            strokeWeight(random(dynamicValue(4), dynamicValue(8)));  //Random thick-beam stroke weight.
            //Draw a thick bezier curve from player to enemy target.
            bezier(player.x, player.y, player.x, player.y - (height-target.enemyPos.y), target.enemyPos.x, target.enemyPos.y + target.eWidth*2, target.enemyPos.x, target.enemyPos.y);
          }
        }
      } 
      break;

      case(5):  //Enemy type 0 shot.
      strokeWeight(dynamicValue(1.5));
      float offset = shotSize/5;
      int flip;
      //Draw 5 lines in zig-zag.
      for (int i = 0; i < 5; i++) {
        if (i%2 == 0) { 
          flip = 1;
        }
        else { 
          flip = -1;
        }
        stroke(255);
        line(shotPos.x - (offset/1.5)*flip, shotPos.y - offset*i, shotPos.x + (offset/1.5)*flip, shotPos.y - offset - offset*i);
      }
      break;
    }
  }

  boolean shotCollision() {
    //Remove shot if out of display bounds.
    if (shotPos.y < 0 + shotSize || shotPos.y > height + shotSize || shotPos.x < 0 - shotSize || shotPos.x > width + shotSize) {
      return true;
    }

    //Check if shot collides with the ground.
    if (shotPos.y >= ground.groundY) {
      //Check which blocks the shot collided with and impact them.
      for (int j = ground.groundBlocks.size()-1; j > -1; j--) {
        if (collisionCheck(shotPos, 0, 0, ground.groundBlocks.get(j).blockPos, 4, 4)) {
          ground.damageGround(ground.groundBlocks, shotPos, ground.blockSize*3, 50);
          return true;
        }
      }
    }

    //Check if shot collides with a cover and trigger ground impact.
    for (int i = 1; i < 5; i++) {
      if (collisionCheck(shotPos, 0, 0, new PVector((width/5)*i, ground.coverY + ground.coverHeight/2), ground.coverWidth/2, ground.coverHeight/2)) {
        //Check which blocks the shot collided with and impact them.
        for (int j = ground.coverBlocks.size()-1; j > -1; j--) {
          if (collisionCheck(shotPos, 0, 0, ground.coverBlocks.get(j).blockPos, 4, 4)) {
            float range = ground.blockSize*3;  //The range within to affect blocks.
            int pct = 75;  //Procentage chance for blocks to be affected.
            if (type == 1) {
              range = ground.blockSize*5;
              pct = 100;
            }
            if (type == 3) {
              range = ground.blockSize*15;
              pct = 85;
            }
            ground.damageGround(ground.coverBlocks, new PVector(shotPos.x, shotPos.y - (shotSize/2)*(shotDir.y-1)), range, pct);
            if (type != 1) { 
              return true;
            }  //Let weapon type 1 pierce through.
          }
        }
      }

      //If type 4 and the player is under a cover then set enemy target to none.
      if (type == 4) {
        if (players.get(owner).x > (width/5)*i - ground.coverWidth/2 && players.get(owner).x < (width/5)*i + ground.coverWidth/2) {
          target = null;
        }
      }
    }

    //Check if player shot collides with an enemy or enemy shot.
    if (shotDir.y < 0) {
      //If it is not type 3 or 4.
      if (type < 3) {
        //Check if player shot collides with an alive enemy.
        for (int i = enemies.size() - 1; i > -1; i--) {
          Enemy _enemy = enemies.get(i);
          if (!_enemy.isDead) {
            if (collisionCheck(shotPos, 0, 0, _enemy.enemyPos, _enemy.eWidth, _enemy.eHeight)) {
              //Damage enemy and remove shot if it is not type 1.
              _enemy.damageEnemy(this);
              if (type != 1) { 
                return true;
              }  //Let weapon type 1 pierce through.
            }
          }
        }

        //Check if player shot collides with an enemy shot.
        for (int i = shots.size()-1; i > -1; i--) {
          Shot _shot = shots.get(i);
          if (_shot != this && collisionCheck(shotPos, 0, 0, _shot.shotPos, _shot.shotSize/2, _shot.shotSize/2)) {
            _shot.destroy = true;  //Destroy collided shot.
            menUI.addFloatingText(players.get(owner), shotPos, nf(points, 0));  //Add floating points
            if (type != 1) { 
              return true;
            }  //Let weapon type 1 pierce through.
          }
        }

        //Check if player shot collides with an enemy death projectiles.
        for (int i = deadEnemies.size()-1; i > -1; i--) {
          Enemy _deathShot = deadEnemies.get(i);
          if (collisionCheck(shotPos, 0, 0, _deathShot.lowestPoint, dynamicValue(5), dynamicValue(5)) && _deathShot.isProjectile) {
            _deathShot.destroy = true;  //Destroy collided shot.
            menUI.addFloatingText(players.get(owner), shotPos, nf(points, 0));  //Add floating points
            if (type != 1) { 
              return true;
            }  //Let weapon type 1 pierce through.
          }
        }
      }
    }
    else {
      //Check if enemy shot collides with an alive player.
      for (int i = players.size() - 1; i > -1; i--) {
        Player _player = players.get(i);
        if (!_player.isDead && collisionCheck(shotPos, 0, 0, new PVector(_player.x, _player.y), _player.pWidth/2, _player.pHeight)) {
          if (_player.hasShield) { 
            _player.hasShield = false;
          }  //If player has shield then remove it,
          else { 
            _player.adjustLifes();
          }  //otherwise damage player and destroy shot.
          return true;
        }
      }
    }

    //Type 3 and 4 collision, if there is an alive enemy target.
    if (target != null) {
      if (!target.isDead) {
        switch(type) {
          //Seeker.
          case(3):
          //Check if shot collides with enemy target.
          if (collisionCheck(shotPos, 0, 0, target.enemyPos, target.eWidth, target.eHeight)) {
            //Damage enemy target and enemies around target.
            for (int i = enemies.size()-1; i > -1; i--) {
              if (collisionCheck(enemies.get(i).enemyPos, 0, 0, shotPos, spawner.enemyStepX*1.5, spawner.enemyStepX*1.5)) {
                enemies.get(i).damageEnemy(this);
              }
            }
            audioHandler.audioBank[7+type].pause();
            return true;
          }
          break;

          //Arc beam.
          case(4):
          //Damage in small intervals.
          if (millis() - lastDmg >= nextDmg) {
            target.damageEnemy(this);
            lastDmg = millis();
          }
          break;
        }
      }
    }
    return false;
  }

  //Setup shot size, speed and damage and with enemy shot also position.
  void setShotStats() {
    shotDir = new PVector(0, -1);  //Player shot direction

    switch(type) {
      //Player shot types.
      //Default shot.
      case(0):
      shotSize = dynamicValue(5);
      speed = dynamicValue(500);
      damage = 6;
      break;
      //Piercer.
      case(1):
      shotSize = dynamicValue(15);
      speed = dynamicValue(500);
      damage = 6;
      break;
      //Rapid fire.
      case(2):
      shotSize = dynamicValue(5);
      speed = dynamicValue(600);
      damage = 2;
      break;
      //Seeker.
      case(3):
      shotSize = dynamicValue(15);
      speed = dynamicValue(300);
      damage = 6;
      break;
      //Arc beam.
      case(4):
      shotSize = 0;
      speed = 0;
      damage = 1;
      break;

      //Enemy shot.
      case(5):
      shotDir = new PVector(0, 1);
      shotSize = dynamicValue(15);
      speed = dynamicValue(300);
      damage = 0;
      shotPos.y += shotSize;
      break;
    }
  }
}

