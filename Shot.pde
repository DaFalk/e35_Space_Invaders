class Shot {
  PVector shotPos, shotDir;
  int lastMove, type, owner, shotSize, speed, damage, lastDmg, nextDmg;
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
    if(!gamePaused) {
      if(type != 4) {
        shotPos.add(new PVector((speed*shotDir.x)*((millis()-lastMove)*0.001), (speed*shotDir.y)*((millis()-lastMove)*0.001)));
        lastMove = millis();
      }
      if(checkCollision()) { shots.remove(this); }
    }
    if(type >= 3) {
      if(target == null) { getEnemyTarget(); }
      else if(target.isDead) { getEnemyTarget(); }
    }
    drawShot();
  }
  
  void getEnemyTarget() {
    if(enemies.size() > 0) {
      target = enemies.get(floor(random(0, enemies.size())));
    }
    else {
      if(type == 4) {
        audioHandler.audioBank[7+type].pause();
        shots.remove(this);
      }
    }
  }
  
//Draw shot related to the owner's weapon type.
  void drawShot() {
    strokeWeight(2);
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
        stroke(0, 126, 0);
        noFill();
        ellipse(target.x, target.y, target.eSize*3, target.eSize*3);
        if (dist(shotPos.x, shotPos.y, target.x, target.y) < target.eSize*5) {
          target.eFill = color(255, 70, 110);
          target.setBlocksFill();
        }
        float _angle = atan2(target.y - shotPos.y, target.x - shotPos.x);
        shotDir = new PVector(cos(_angle), sin(_angle));
        stroke(126, 0, 0);
        line(shotPos.x, shotPos.y, shotPos.x - shotSize*cos(_angle), shotPos.y + abs(shotSize*sin(_angle)));
      break;
      
      case(4):  //Curved laser.
        if(owner < 2) {
          if(player.attack && player.weaponType == 4) {
            noFill();
            stroke(10, 210, 210, random(20, 100));
            strokeWeight(2.5);
            float _x = player.x + player.pWidth/2;
            float _y = player.y - player.pHeight/2;
            if(target != null) {
              bezier(_x, _y, _x, _y - (height-target.y), target.x, target.y + target.eSize*2, target.x, target.y);
              stroke(110, 255, 255, random(0, 75));
              strokeWeight(ceil(random(4, 8)));
              bezier(_x, _y, _x, _y - (height-target.y), target.x, target.y + target.eSize*2, target.x, target.y);
            }
          }
          if(!player.attack && player.weaponType != 4) {
            audioHandler.audioBank[7+type].pause();
            shots.remove(this);
          }
        }
      break;
      
      case(5):  //Enemy type 0 shot.
        strokeWeight(1.5);
        float offset = shotSize/5;
        int flip;
        for(int i = 0; i < 5; i++) {
          if(i%2 == 0) { flip = 1; }
          else { flip = -1; }
          float _diff = norm(cover.groundY - shotPos.y, 0, cover.groundY)*i;
          stroke(255 - _diff, 255, 255 - _diff);
          line(shotPos.x - (offset/1.5)*flip, shotPos.y - offset*i, shotPos.x + (offset/1.5)*flip, shotPos.y - offset - offset*i);
        }
      break;
    }
  }
  
  boolean checkCollision() {
   //Special collision for type 4
    if(type == 4) {
      if(millis() - lastDmg >= nextDmg) {
        target.damageEnemy(this);
        lastDmg = millis();
      }
      return false; //return is used to avoid the rest of the code
    }
    
   //Remove shot if out of bounds
    if(shotPos.y < 0 || shotPos.y > cover.groundY || shotPos.x < 0 || shotPos.x > width) {
      return true;
    }
    
   //Special collision for type 3
    if(type == 3 && target != null) {
      if(!target.isDead) {
        if(shotPos.y < target.y + target.eHeight && shotPos.y > target.y - target.eHeight) {
          if(shotPos.x < target.x + target.eSize && shotPos.x > target.x - target.eSize) {
            target.damageEnemy(this);
            audioHandler.audioBank[7+type].pause();
            return true;
          }
        }
      }
      else {
        getEnemyTarget();
        return false;
      }
    }
    
    //Check if player shot collides with an enemy
    if(shotDir.y < 0) {
      for(int i = enemies.size() - 1; i > -1; i--) {
        Enemy _enemy = enemies.get(i);
        if(!_enemy.isDead) {
          if(shotPos.y < _enemy.y + _enemy.eHeight && shotPos.y > _enemy.y - _enemy.eHeight) {
            if(shotPos.x < _enemy.x + _enemy.eSize && shotPos.x > _enemy.x - _enemy.eSize) {
              enemies.get(i).damageEnemy(this);
              if(type != 1) { return true; }
            }
          }
        }
      }
      return false;
    }
    
    //Check if enemy shot collides with a player
    if(shotDir.y > 0) {
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
    return false;
  }
  
  void setShotStats() {
    this.shotDir = new PVector(0, -1);
    switch(type) {
      case(0):
        this.shotSize = 5;
        this.speed = 500;
        this.damage = 6;
      break;
      case(1):
        this.shotSize = 15;
        this.speed = 500;
        this.damage = 6;
      break;
      case(2):
        this.shotSize = 5;
        this.speed = 600;
        this.damage = 2;
      break;
      case(3):
        this.shotSize = 15;
        this.speed = 300;
        this.damage = 6;
      break;
      case(4):
        this.shotSize = 0;
        this.speed = 0;
        this.damage = 1;
      break;
      case(5):
        this.shotDir = new PVector(0, 1);
        this.shotSize = 15;
        this.speed = 300;
        this.damage = 0;
        shotPos.y += shotSize;
      break;
    }
  }
}
