class Shot {
  PVector shotPos, shotDir;
  int lastMove, type, owner;
  int shotSize = 5;
  int speed = 500;
  Enemy target;
  
  Shot(PVector _shotPos, int _type, int _owner) {
    this.owner = _owner;
    this.type = _type;
    this.shotPos = _shotPos;
    this.lastMove = millis();
    this.target = enemies.get(ceil(random(0, enemies.size()-1)));
    if(owner < players.size()) {
      this.shotDir = new PVector(0, -1);
    }
    else {
      this.shotDir = new PVector(0, 1);
    }
    audioHandler.playSFX(2+type);
  }
  
  void update() {
    if(!gamePaused) {
      shotPos.add(new PVector((speed*shotDir.x)*((millis()-lastMove)*0.001), (speed*shotDir.y)*((millis()-lastMove)*0.001)));
      lastMove = millis();
      if(checkCollision()) {
        shots.remove(this);
      }
    }
    if(owner <= 1) { drawPlayerShot(); }
    else { drawEnemyShot(); }
  }
  
  void drawPlayerShot() {
    //Draw the shot related the player's weapon type.
    strokeWeight(2);
    if(type == 0) {
      stroke(255, 255, 255);
      line(shotPos.x, shotPos.y, shotPos.x, shotPos.y + shotSize);
    }
    else if(type == 1) {
      noStroke();
      fill(0, 0, 255);
      triangle(shotPos.x - shotSize/2, shotPos.y, shotPos.x + shotSize/2, shotPos.y, shotPos.x, shotPos.y + shotSize);
    }
    else if(type == 2) {
      stroke(255, 255, 255);
      float angle = atan2(target.y - shotPos.y, target.x - shotPos.x);
      shotDir = new PVector(cos(angle), sin(angle));
      line(shotPos.x, shotPos.y, shotPos.x - shotSize*cos(angle), shotPos.y + abs(shotSize*sin(angle)));
    }
    else if(type == 3) {
      stroke(255, 255, 255);
      float angle = atan2(target.y - shotPos.y, target.x - shotPos.x);
      shotDir = new PVector(cos(angle), sin(angle));
      line(shotPos.x, shotPos.y, shotPos.x - shotSize*cos(angle), shotPos.y + abs(shotSize*sin(angle)));
    }
    else if(type == 4) {
      if(players.get(owner).attack == true && players.get(owner).weaponType == 4) {
        drawCurveLaser();
        return;
      }
      audioHandler.audioBank[5].pause();
      shots.remove(this);
    }
  }
  
  void drawCurveLaser() {
    noFill();
    stroke(0, 220, 0, 150);
    strokeWeight(2);
    float _x = players.get(owner).x + players.get(owner).pWidth/2;
    float _y = players.get(owner).y;
    for(int i = enemies.size()-1; i > -1; i--) {
      target = enemies.get(i);
    }
    bezier(_x, _y, _x, _y - (_y - width/2), target.x, target.y + (width/2 - target.y), target.x, target.y);
  }
  
  void drawEnemyShot() {
    stroke(255, 255, 255);
    strokeWeight(2);
    float offset = shotSize/5;
    int flip;
    for (int i = 0; i < 5; i++) {
      if(i%2 == 0) { flip = 1; }
      else { flip = -1; }
      line(shotPos.x - offset*flip, shotPos.y + offset*i, shotPos.x + offset*flip, shotPos.y + offset + offset*i);
    }
  }
  
  boolean checkCollision() {
    if((shotPos.y < 0 && shotDir.y < 0) || (shotPos.y > height + shotSize && shotDir.y > 0)) {
      if(type == 4) {
        target.killEnemy();
        players.get(owner).score += target.points;
      }
      return true;
    }
    //Check to see if this shot collides with a enemy
    if(shotDir.y < 0 && type != 4) {
      for(int i = enemies.size() - 1; i > -1; i--) {
        Enemy _enemy = enemies.get(i);
        if(shotPos.y < _enemy.y + _enemy.eHeight && shotPos.y > _enemy.y - _enemy.eHeight) {
          if(shotPos.x < _enemy.x + _enemy.eSize && shotPos.x > _enemy.x - _enemy.eSize) {
            enemies.get(i).killEnemy();
            players.get(owner).score += _enemy.points;
            if(type != 1) {
              return true;
            }
          }
        }
      }
      return false;
    }
    
    //Check to see if this shot collides with a player
    if(shotDir.y > 0) {
      for(int i = players.size() - 1; i > -1; i--) {
        Player _player = players.get(i);
        if(!_player.isDead) {
          if((shotPos.y > _player.y - _player.pHeight - _player.pHeight/3 && shotPos.y < _player.y + _player.pHeight)) {
            if((shotPos.x > _player.x && shotPos.x < _player.x + _player.pWidth)) {
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
