class Shot {
  PVector shotPos, shotDir;
  int lastMove, type, owner;
  int shotSize;
  int speed;
  int lastShot;
  int cooldown;
  Enemy target;

  Shot(PVector _shotPos, int _type, int _owner) {
    this.owner = _owner;
    this.type = _type;
    this.shotPos = _shotPos;
    this.lastMove = millis();
    this.target = enemies.get(ceil(random(0, enemies.size()-1)));
    this.lastShot = millis();
    if (owner < players.size()) {
      this.cooldown = players.get(owner).shotCooldown;
      this.shotDir = new PVector(0, -1);
      this.shotSize = 5;
      this.speed = 500;
      if (type > 0) {
        this.shotSize = 15;
        if(type == 3) { speed = 200; }
      }
    }
    else {
      this.shotDir = new PVector(0, 1);
      this.shotSize = 15;
      this.shotPos.y += shotSize;
      this.speed = 300;
    }
    audioHandler.playSFX(2+type);
  }

  void update() {
    if (!gamePaused) {
      shotPos.add(new PVector((speed*shotDir.x)*((millis()-lastMove)*0.001), (speed*shotDir.y)*((millis()-lastMove)*0.001)));
      lastMove = millis();
      if (checkCollision()) { shots.remove(this); }
    }
    if (owner <= 1) { drawPlayerShot(); }
    else { drawEnemyShot(); }
  }

  void drawPlayerShot() {
    //Draw the shot related the player's weapon type.
    strokeWeight(2);
    if (type == 0) {
      stroke(255, 255, 255);
      line(shotPos.x, shotPos.y, shotPos.x, shotPos.y + shotSize);
    }
    else if (type == 1) {
      noStroke();
      fill(0, 0, 255);
      triangle(shotPos.x - shotSize/2, shotPos.y, shotPos.x + shotSize/2, shotPos.y, shotPos.x, shotPos.y + shotSize);
    }
    else if (type == 2) {
      stroke(255, 255, 255);
      float angle = atan2(target.y - shotPos.y, target.x - shotPos.x);
      shotDir = new PVector(cos(angle), sin(angle));
      line(shotPos.x, shotPos.y, shotPos.x - shotSize*cos(angle), shotPos.y + abs(shotSize*sin(angle)));
    }
    else if (type == 3) {
      stroke(126, 126, 126);
      float angle = atan2(target.y - shotPos.y, target.x - shotPos.x);
      shotDir = new PVector(cos(angle), sin(angle));
      line(shotPos.x, shotPos.y, shotPos.x - shotSize*cos(angle), shotPos.y + abs(shotSize*sin(angle)));
    }
    else if (type == 4) {
      if (players.get(owner).attack == true && players.get(owner).weaponType == 4) {
        noFill();
        stroke(0, 220, 0, 150);
        strokeWeight(2);
        float _x = players.get(owner).x + players.get(owner).pWidth/2;
        float _y = players.get(owner).y;
        for (int i = enemies.size()-1; i > -1; i--) {
          target = enemies.get(i);
        }
        bezier(_x, _y, _x, _y - (_y - width/2), target.x, target.y + (width/2 - target.y), target.x, target.y);
        return;
      }
      audioHandler.audioBank[5].pause();
      shots.remove(this);
    }
  }

  void drawEnemyShot() {
    strokeWeight(1.5);
    if (type == 0) {
      float offset = shotSize/5;
      int flip;
      for (int i = 0; i < 5; i++) {
        if (i%2 == 0) { flip = 1; }
        else { flip = -1; }
        float _diff = norm(cover.groundY - shotPos.y, 0, cover.groundY)*i;
        stroke(255 - _diff, 255, 255 - _diff);
        line(shotPos.x - (offset/1.5)*flip, shotPos.y - offset*i, shotPos.x + (offset/1.5)*flip, shotPos.y - offset - offset*i);
      }
    }
  }

  boolean checkCollision() {
    //Remove shot if out of bounds
    if (shotPos.y < 0 || shotPos.y > cover.groundY || shotPos.x < 0 || shotPos.x > width) {
      return true;
    }
    
    //Special collision for type 3 and 4
    if (type == 3 || type == 4) {
      if(type == 3) {
        if(target.isDead) {
          this.target = enemies.get(ceil(random(0, enemies.size()-1)));
        }
        if (shotPos.y < target.y + target.eHeight && shotPos.y > target.y - target.eHeight) {
          if (shotPos.x < target.x + target.eSize && shotPos.x > target.x - target.eSize) {
            target.killEnemy();
            players.get(owner).score += target.points;
            if (type != 1) {
              return true;
            }
          }
        }
      }
      if(type == 4) {
        if(millis() - lastShot >= cooldown) {
          target.killEnemy();
          players.get(owner).score += target.points;
          lastShot = millis();
          return true;
        }
      }
      return false;
    }

    //Check if player shot collides with an enemy
    if (shotDir.y < 0) {
      for (int i = enemies.size() - 1; i > -1; i--) {
        Enemy _enemy = enemies.get(i);
        if (!_enemy.isDead) {
          if (shotPos.y < _enemy.y + _enemy.eHeight && shotPos.y > _enemy.y - _enemy.eHeight) {
            if (shotPos.x < _enemy.x + _enemy.eSize && shotPos.x > _enemy.x - _enemy.eSize) {
              enemies.get(i).killEnemy();
              players.get(owner).score += _enemy.points;
              if (type != 1) {
                return true;
              }
            }
          }
        }
      }
      return false;
    }

    //Check if enemy shot collides with a player
    if (shotDir.y > 0) {
      for (int i = players.size() - 1; i > -1; i--) {
        Player _player = players.get(i);
        if (!_player.isDead) {
          if ((shotPos.y > _player.y - _player.pHeight - _player.pHeight/3 && shotPos.y < _player.y + _player.pHeight)) {
            if ((shotPos.x > _player.x && shotPos.x < _player.x + _player.pWidth)) {
              _player.adjustLifes();
              return true;
            }
          }
        }
      }
    }
    return false;
  }
}

