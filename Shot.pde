class Shot {
  PVector shotPos, shotDir;
  int lastMove, type, owner, shotSize, speed, damage, lastDmg, nextDmg;
  Enemy target;
  PVector staticTarget;

  Shot(PVector _shotPos, int _type, int _owner) {
    this.owner = _owner;
    this.type = _type;
    this.damage = damage;
    this.shotPos = _shotPos;
    this.lastMove = millis();
    this.lastDmg = millis();
    this.nextDmg = 200;
    this.speed = speed;
    this.shotSize = shotSize;
    this.shotDir = shotDir;
    setShotStats();
    target = enemies.get(ceil(random(0, enemies.size()-1)));
    staticTarget = new PVector(random(shotPos.x - shotSize*20, shotPos.x + shotSize*20), -shotSize);
    audioHandler.playSFX(7+type);
  }

  void update() {
    if(!gamePaused) {
      shotPos.add(new PVector((speed*shotDir.x)*((millis()-lastMove)*0.001), (speed*shotDir.y)*((millis()-lastMove)*0.001)));
      lastMove = millis();
      if(checkCollision()) {
        shots.remove(this);
      }
    }
    drawShot();
  }
  
//Draw shot related to the owner's weapon type.
  void drawShot() {
    strokeWeight(2);
    switch(type) {
      case(0):
        stroke(255, 255, 255);
        line(shotPos.x, shotPos.y, shotPos.x, shotPos.y + shotSize);
      break;
      case(1):
        noStroke();
        fill(0, 0, 255);
        triangle(shotPos.x - shotSize/2, shotPos.y, shotPos.x + shotSize/2, shotPos.y, shotPos.x, shotPos.y + shotSize);
      break;
      case(2):
        stroke(126, 126, 126);
        float angle = atan2(staticTarget.y - shotPos.y, staticTarget.x - shotPos.x);
        shotDir = new PVector(cos(angle), sin(angle));
        line(shotPos.x, shotPos.y, shotPos.x - shotSize*cos(angle), shotPos.y + abs(shotSize*sin(angle)));
      break;
      case(3):
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
      case(4):
        if(owner < 2) {
          Player _player = players.get(owner);
          if(_player.attack && _player.weaponType == 4) {
            noFill();
            stroke(0, 220, 0, 150);
            float _x = _player.x + _player.pWidth/2;
            float _y = _player.y;
            for(int i = enemies.size()-1; i > -1; i--) {
              target = enemies.get(i);
            }
            if(!target.isDead) {
              bezier(_x, _y, _x, _y - (_y - width/2), target.x, target.y + (width/2 - target.y), target.x, target.y);
            }
          }
          if((!_player.attack && _player.weaponType != 4) || target.isDead) {
            audioHandler.audioBank[7+type].pause();
            shots.remove(this);
          }
        }
      break;
      case(5):
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
    if(type == 4 && !target.isDead) {
      if(millis() - lastDmg >= nextDmg) {
        target.damageEnemy(owner, damage);
        lastDmg = millis();
        return true;
      }
      return false; //return is used to avoid the rest of the code
    }
   //Remove shot if out of bounds
    if(shotPos.y < 0 || shotPos.y > cover.groundY || shotPos.x < 0 || shotPos.x > width) {
      return true;
    }
   //Special collision for type 3
    if(type == 3 && !target.isDead) {
      if(target.isDead) {
        this.target = enemies.get(ceil(random(0, enemies.size()-1)));
      }
      if(shotPos.y < target.y + target.eHeight && shotPos.y > target.y - target.eHeight) {
        if(shotPos.x < target.x + target.eSize && shotPos.x > target.x - target.eSize) {
          target.damageEnemy(owner, damage);
          audioHandler.audioBank[7+type].pause();
          return true;
        }
      }
      return false;
    }
    //Check if player shot collides with an enemy
    if(shotDir.y < 0) {
      for(int i = enemies.size() - 1; i > -1; i--) {
        Enemy _enemy = enemies.get(i);
        if(!_enemy.isDead) {
          if(shotPos.y < _enemy.y + _enemy.eHeight && shotPos.y > _enemy.y - _enemy.eHeight) {
            if(shotPos.x < _enemy.x + _enemy.eSize && shotPos.x > _enemy.x - _enemy.eSize) {
              enemies.get(i).damageEnemy(owner, damage);
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
    switch(type) {
      case(0):
        shotDir = new PVector(0, -1);
        shotSize = 5;
        speed = 500;
        damage = 6;
      break;
      case(1):
        shotDir = new PVector(0, -1);
        shotSize = 15;
        speed = 500;
        damage = 6;
      break;
      case(2):
        shotDir = new PVector(0, -1);
        shotSize = 5;
        speed = 600;
        damage = 2;
      break;
      case(3):
        shotDir = new PVector(0, -1);
        shotSize = 15;
        speed = 300;
        damage = 6;
      break;
      case(4):
        shotDir = new PVector(0, 0);
        speed = 0;
        damage = 1;
      break;
      case(5):
        shotDir = new PVector(0, 1);
        shotSize = 15;
        shotPos.y += shotSize;
        speed = 300;
      break;
    }
  }
}

