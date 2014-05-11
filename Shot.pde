class Shot {
  PVector shotPos, shotDir;
  int lastMove, type, owner, damage, lastDmg, nextDmg;
  float shotSize, speed;
  Player player;
  Enemy target;
  PVector staticTarget;

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
      if(checkCollision()) { shots.remove(this); }
    }
    else {
      //Adjust lastMove in order to pause shot.
      lastMove += millis() - lastMove;
    }
    drawShot();
  }
  
//Target new random enemy or remove shot.
  void getEnemyTarget() {
    if(enemies.size() > 0) { target = enemies.get(floor(random(0, enemies.size()))); }
    else if(type == 4) {
      audioHandler.audioBank[7+type].pause();
      shots.remove(this);
    }
  }
  
//Draw shot related to the owner's weapon type.
  void drawShot() {
    strokeWeight(0.0025*width);
    switch(type) {
      case(0):  //Default shot.
        stroke(255, 255, 255);
        line(shotPos.x, shotPos.y, shotPos.x, shotPos.y + shotSize);
      break;
      
      case(1):  //Piercing shot.
        noStroke();
        fill(0, 0, 255);
        triangle(shotPos.x - shotSize/2, shotPos.y, shotPos.x + shotSize/2, shotPos.y, shotPos.x, shotPos.y + shotSize);
      break;
      
      case(2):  //Rapid fire
        stroke(126, 126, 126);
        float angle = atan2(staticTarget.y - shotPos.y, staticTarget.x - shotPos.x);
        shotDir = new PVector(cos(angle), sin(angle));
        line(shotPos.x, shotPos.y, shotPos.x - shotSize*cos(angle), shotPos.y + abs(shotSize*sin(angle)));
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
            line(shotPos.x, shotPos.y, shotPos.x - shotSize*cos(_angle), shotPos.y + abs(shotSize*sin(_angle)));
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
            strokeWeight(0.003125*width);
            float _x = player.x + player.pWidth/2;
            float _y = player.y - player.pHeight/2;
            if(target != null) {
              bezier(_x, _y, _x, _y - (height-target.enemyPos.y), target.enemyPos.x, target.enemyPos.y + target.eSize*2, target.enemyPos.x, target.enemyPos.y);
              stroke(110, 255, 255, random(0, 75));
              strokeWeight(random(0.005, 0.01)*width);
              bezier(_x, _y, _x, _y - (height-target.enemyPos.y), target.enemyPos.x, target.enemyPos.y + target.eSize*2, target.enemyPos.x, target.enemyPos.y);
            }
          }
        } 
      break;
      
      case(5):  //Enemy type 0 shot.
        strokeWeight(0.001875*width);
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
  
  boolean checkCollision() {
   //Remove shot if out of bounds
    if(shotPos.y < 0 || shotPos.y >= ground.groundY || shotPos.x < 0 || shotPos.x > width) {
      if(shotPos.y >= ground.groundY) { ground.damageGround(shotPos); }
      return true;
    }
    
    if(shotDir.y < 0) {  //Check if player shot collides with an enemy
      if(type < 3) {
        for(int i = enemies.size() - 1; i > -1; i--) {
          Enemy _enemy = enemies.get(i);
          if(!_enemy.isDead) {
            if(shotPos.y > _enemy.enemyPos.y - _enemy.eHeight && shotPos.y < _enemy.enemyPos.y + _enemy.eHeight) {
              if(shotPos.x > _enemy.enemyPos.x - _enemy.eSize && shotPos.x < _enemy.enemyPos.x + _enemy.eSize) {
                enemies.get(i).damageEnemy(this);
                if(type != 1) { return true; }
              }
            }
          }
        }
      }
    }
    else {  //Check if enemy shot collides with a player
      for(int i = players.size() - 1; i > -1; i--) {
        Player _player = players.get(i);
        if(!_player.isDead) {
          if((shotPos.y > _player.y - _player.pHeight - _player.pHeight/3 && shotPos.y < _player.y + _player.pHeight)) {
            if((shotPos.x > _player.x && shotPos.x < _player.x + _player.pWidth)) {
              if(_player.hasShield) { _player.hasShield = false; }
              else { _player.adjustLifes(); }
              return true;
            }
          }
        }
      }
    }
    
    if(target != null) {
      if(!target.isDead) {
        switch(type) {
          case(3):
            if(shotPos.y < target.enemyPos.y + target.eHeight && shotPos.y > target.enemyPos.y - target.eHeight) {
              if(shotPos.x < target.enemyPos.x + target.eSize && shotPos.x > target.enemyPos.x - target.eSize) {
                for(int i = enemies.size()-1; i > -1; i--) {
                  if(enemies.get(i).enemyPos.y < shotPos.y + spawner.enemyStepX*1.5 && enemies.get(i).enemyPos.y > shotPos.y - spawner.enemyStepX*1.5) {
                    if(enemies.get(i).enemyPos.x < shotPos.x + spawner.enemyStepX*1.5 && enemies.get(i).enemyPos.x > shotPos.x - spawner.enemyStepX*1.5) {
                      enemies.get(i).damageEnemy(this);
                    }
                  }
                }
                audioHandler.audioBank[7+type].pause();
                return true;
              }
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
        shotSize = 0.00625*width;  //0.00625 = speed (5) divided by the original width (800)
        speed = 0.625*width;
        damage = 6;
      break;
      case(1):
        shotSize = 0.01875*width;
        speed = 0.625*width;
        damage = 6;
      break;
      case(2):
        shotSize = 0.00625*width;
        speed = 0.75*width;
        damage = 2;
      break;
      case(3):
        shotSize = 0.01875*width;
        speed = 0.375*width;
        damage = 6;
      break;
      case(4):
        shotSize = 0;
        speed = 0;
        damage = 1;
      break;
      case(5):
        shotDir = new PVector(0, 1);
        shotSize = 0.01875*width;
        speed = 0.375*width;
        damage = 0;
        shotPos.y += shotSize;
      break;
    }
  }
}
