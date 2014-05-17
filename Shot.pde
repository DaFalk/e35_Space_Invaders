//
//
//

class Shot {
  PVector shotPos, shotDir;
  int lastMove, type, owner, damage, lastDmg, nextDmg;
  int points = 2;
  float shotSize, speed;
  Player player;
  Enemy target;
  PVector staticTarget;
  boolean destroy = false;

  Shot(PVector _shotPos, int _type, int _owner) {
    owner = _owner;
    if(owner < 2) { player = players.get(owner); }
    type = _type;
    shotPos = _shotPos;
    lastMove = millis();
    lastDmg = millis();
    nextDmg = 200;
    setShotStats();
    getEnemyTarget();
    staticTarget = new PVector(random(shotPos.x - shotSize*20, shotPos.x + shotSize*20), -shotSize);
    audioHandler.playSFX(7+type);
  }

  void update() {
    if(type >= 3) {
      //Get a new target if the old target was killed or if the target is none.
      if(target == null) { getEnemyTarget(); }
      else if(target.isDead) { getEnemyTarget(); }
    }
    if(!gamePaused) {
      if(type != 4) {
        shotPos.add(new PVector(timeFix(speed*shotDir.x, lastMove), timeFix(speed*shotDir.y, lastMove)));
        lastMove = millis();
      }
      //Destroy shot if it triggers a collision.
      if(shotCollision() || destroy) { shots.remove(this); }
    }
    else {
      //Adjust lastMove in order to pause shot.
      lastMove += millis() - lastMove;
    }
    drawShot();
  }
  
//Target new random enemy or remove shot.
  void getEnemyTarget() {
    if(enemies.size() > 0) {
      target = enemies.get(floor(random(0, enemies.size())));
      if((type == 4 || type == 3) && target == enemyHandler.boss) {
        audioHandler.audioBank[7+type].pause();
        target = null;
      }
    }
    else if(type == 4 || type == 3) {
      audioHandler.audioBank[7+type].pause();
      shots.remove(this);
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
      
      case(1):  //Piercing shot.
        noStroke();
        fill(0, 0, 255);
        triangle(shotPos.x - shotSize/2, shotPos.y, shotPos.x + shotSize/2, shotPos.y - shotSize/2, shotPos.x, shotPos.y + shotSize);
      break;
      
      case(2):  //Rapid fire
        stroke(126, 126, 126);
        float angle = atan2(staticTarget.y - shotPos.y, staticTarget.x - shotPos.x);
        shotDir = new PVector(cos(angle), sin(angle));
        line(shotPos.x, shotPos.y, shotPos.x - shotSize*cos(angle), shotPos.y + abs((shotSize)*sin(angle)));
      break;
      
      case(3):  //Homeseeking missile.
        if(target != null) {
          if(!target.isDead) {
            stroke(0, 126, 0);
            noFill();
            ellipse(target.enemyPos.x, target.enemyPos.y, target.eSize*3, target.eSize*3);
            float _angle = atan2(target.enemyPos.y - shotPos.y, target.enemyPos.x - shotPos.x);
            shotDir = new PVector(cos(_angle), sin(_angle));
            stroke(126, 0, 0);
            line(shotPos.x, shotPos.y, shotPos.x - shotSize*cos(_angle), shotPos.y + abs((shotSize)*sin(_angle)));
          }
        }
      break;
      
      case(4):  //Curved laser.
        if(target != null) {
          if(!target.isDead) {
            if(!player.attack || player.weaponType != 4) {
              audioHandler.audioBank[7+type].pause();
              shots.remove(this);
              return;
            }
            noFill();
            stroke(10, 210, 210, random(20, 100));
            strokeWeight(dynamicValue(2.5));
            if(target != null) {
              bezier(player.x, player.y, player.x, player.y - (height-target.enemyPos.y), target.enemyPos.x, target.enemyPos.y + target.eSize*2, target.enemyPos.x, target.enemyPos.y);
              stroke(110, 255, 255, random(0, 75));
              strokeWeight(random(dynamicValue(4), dynamicValue(8)));
              bezier(player.x, player.y, player.x, player.y - (height-target.enemyPos.y), target.enemyPos.x, target.enemyPos.y + target.eSize*2, target.enemyPos.x, target.enemyPos.y);
            }
          }
        } 
      break;
      
      case(5):  //Enemy type 0 shot.
        strokeWeight(dynamicValue(1.5));
        float offset = shotSize/5;
        int flip;
        for(int i = 0; i < 5; i++) {
          if(i%2 == 0) { flip = 1; }
          else { flip = -1; }
          stroke(255);
          line(shotPos.x - (offset/1.5)*flip, shotPos.y - offset*i, shotPos.x + (offset/1.5)*flip, shotPos.y - offset - offset*i);
        }
      break;
    }
  }
  
  boolean shotCollision() {
   //Remove shot if out of display bounds.
    if(shotPos.y < 0 + shotSize || shotPos.y > height + shotSize || shotPos.x < 0 - shotSize || shotPos.x > width + shotSize) {
      return true;
    }
    
    if(shotPos.y >= ground.groundY) {
      for(int j = ground.groundBlocks.size()-1; j > -1; j--) {
        if(collisionCheck(shotPos, ground.groundBlocks.get(j).blockPos, 4, 4)) {
          ground.damageGround(ground.groundBlocks, shotPos, ground.blockSize*3, 50);
          return true;
        }
      }
    }
    
    //Check if shot collides with a cover and trigger ground impact.
    for(int i = 1; i < 5; i++) {
      if(collisionCheck(shotPos, new PVector((width/5)*i, ground.coverY + ground.coverHeight/2), ground.coverWidth/2, ground.coverHeight/2)) {
        for(int j = ground.coverBlocks.size()-1; j > -1; j--) {
          if(collisionCheck(shotPos, ground.coverBlocks.get(j).blockPos, 4, 4)) {
            float range = ground.blockSize*3;
            int pct = 50;
            if(type == 1) {
              range = ground.blockSize*5;
              pct = 100;
            }
            if(type == 3) {
              range = ground.blockSize*12;
              pct = 85;
            }
            ground.damageGround(ground.coverBlocks, new PVector(shotPos.x, shotPos.y - (shotSize/2)*(shotDir.y-1)), range, pct);
            if(type != 1) { return true; }
          }
        }
      }
      
      if(type == 4) {
        if(players.get(owner).x > (width/5)*(1+i) - ground.coverWidth/2 && players.get(owner).x < (width/5)*(1+i) + ground.coverWidth/2) {
          target = null;
        }
      }
    }
    
    //Check if player shot collides with an enemy or enemy shot.
    if(shotDir.y < 0) {
      if(type < 3) {
        //Check if player shot collides with an enemy.
        for(int i = enemies.size() - 1; i > -1; i--) {
          Enemy _enemy = enemies.get(i);
          if(!_enemy.isDead) {
            if(collisionCheck(shotPos, _enemy.enemyPos, _enemy.eSize, _enemy.eHeight)) {
              _enemy.damageEnemy(this);
              if(type != 1) { return true; }
            }
          }
        }
        //Check if player shot collides with an enemy shot.
        for(int i = shots.size()-1; i > -1; i--) {
          Shot _shot = shots.get(i);
          if(_shot != this && collisionCheck(shotPos, _shot.shotPos, _shot.shotSize/2, _shot.shotSize/2)) {
            _shot.destroy = true;  //Destroy collided shot.
            menUI.addFloatingText(players.get(owner), shotPos, nf(points, 0));  //Add floating points
            return true;
          }
        }
        //Check if player shot collides with an enemy death projectiles.
        for(int i = deadEnemies.size()-1; i > -1; i--) {
          Enemy _deathShot = deadEnemies.get(i);
          if(collisionCheck(shotPos, _deathShot.lowestPoint, dynamicValue(5), dynamicValue(5)) && _deathShot.isProjectile) {
            _deathShot.destroy = true;  //Destroy collided shot.
            menUI.addFloatingText(players.get(owner), shotPos, nf(points, 0));  //Add floating points
            return true;
          }
        }
      }
    }
    else {
      //Check if enemy shot collides with a player
      for(int i = players.size() - 1; i > -1; i--) {
        Player _player = players.get(i);
        if(!_player.isDead && collisionCheck(shotPos, new PVector(_player.x, _player.y), _player.pWidth/2, _player.pHeight)) {
          if(_player.hasShield) { _player.hasShield = false; }
          else { _player.adjustLifes(); }
          return true;
        }
      }
    }
    
    if(target != null) {
      if(!target.isDead) {
        switch(type) {
          case(3):
            if(collisionCheck(shotPos, target.enemyPos, target.eSize, target.eHeight)) {
              for(int i = enemies.size()-1; i > -1; i--) {
                if(collisionCheck(enemies.get(i).enemyPos, shotPos, spawner.enemyStepX*1.5, spawner.enemyStepX*1.5)) {
                  enemies.get(i).damageEnemy(this);
                }
              }
              audioHandler.audioBank[7+type].pause();
              return true;
            }
          break;
          case(4):
            if(millis() - lastDmg >= nextDmg) {
              target.damageEnemy(this);
              lastDmg = millis();
            }
          break;
        }
      }
    }
    
    return false;
  }
  
  void setShotStats() {
    this.shotDir = new PVector(0, -1);
    switch(type) {
      case(0):
        shotSize = dynamicValue(5);
        speed = dynamicValue(500);
        damage = 6;
      break;
      case(1):
        shotSize = dynamicValue(15);
        speed = dynamicValue(500);
        damage = 6;
      break;
      case(2):
        shotSize = dynamicValue(5);
        speed = dynamicValue(600);
        damage = 2;
      break;
      case(3):
        shotSize = dynamicValue(15);
        speed = dynamicValue(300);
        damage = 6;
      break;
      case(4):
        shotSize = 0;
        speed = 0;
        damage = 1;
      break;
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
