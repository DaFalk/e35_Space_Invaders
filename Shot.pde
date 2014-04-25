class Shot {
  float x, y;
  int dir, lastMove, type, owner;
  int shotSize = 15;
  int speed = 250;
  Enemy target;
  
  Shot(float _x, float _y, int _direction, int _type, int _owner) {
    this.x = _x;
    this.y = _y;
    this.dir = _direction;
    this.lastMove = millis();
    this.type = _type;
    this.owner = _owner;
    this.target = target;
    audioHandler.playSFX(1);
  }
  
  void update() {
    if(!gamePaused) {
      y += (speed*dir)*((millis()-lastMove)*0.001);
      lastMove = millis();
      if(checkCollision()) {
        shots.remove(this);
      }
    }
    if(owner <= 1) {
      drawPlayerShot();
    }
    else {
      drawEnemyShot();
    }
  }
  
  void drawPlayerShot() {
    if(type == 0) {
      stroke(255, 255, 255);
      strokeWeight(2);
      line(x, y, x, y + shotSize);
    }
    if(type == 1) {
      noStroke();
      fill(0, 0, 255);
      triangle(x - shotSize/2, y, x + shotSize/2, y, x, y + shotSize);
    }
    if(type == 2) {
      drawCurveLaser();
    }
  }
  
  
  void drawCurveLaser() {
    noFill();
    stroke(0, 220, 0, 150);
    float _x = players.get(owner).x + players.get(owner).pWidth/2;
    float _y = players.get(owner).y;
    for(int i = enemies.size()-1; i > -1; i--) {
      if(i == enemies.size()-1) {
        target = enemies.get(i);
      }
      if(dist(_x, _y, enemies.get(i).x, enemies.get(i).y) < dist(_x, _y, target.x, target.y) ) {
        target = enemies.get(i);
      }
    }
    bezier(_x, _y, _x, _y - (_y - width/2), target.x, target.y + (width/2 - target.y), target.x, target.y);
  }
  
  void drawEnemyShot() {
    stroke(255, 255, 255);
    float offset = shotSize/5;
    int flip;
    for (int i = 0; i < 5; i++) {
      if(i%2 == 0) { flip = 1; }
      else { flip = -1; }
      line(x - offset*flip, y + offset*i, x + offset*flip, y + offset + offset*i);
    }
  }
  
  boolean checkCollision() {
    if((y < 0 && dir < 0) || (y > height + shotSize && dir > 0)) {
      if(type >= 2) {
        enemies.remove(target);
        players.get(owner).adjustScore();
      }
      return true;
    }
    if(dir < 0) {
      for(int i = enemies.size() - 1; i > -1; i--) { //Correct when enemy y problem is solved.
        if(y < enemies.get(i).y + enemies.get(i).eSize/2 && y > enemies.get(i).y - enemies.get(i).eSize/2) {
          if(x < enemies.get(i).x + enemies.get(i).eSize/2 && x > enemies.get(i).x - enemies.get(i).eSize/2) {
            players.get(owner).adjustScore();
            if(enemies.size() >= 1) {
              spawner.spawnPowerUp(enemies.get(i).x, enemies.get(i).y, enemies.get(i).eSize);
            }
            enemies.remove(i);
            if(enemies.size() == 0) {
              spawner.respawnEnemies();
            }
            if(type != 1) {
              return true;
            }
          }
        }
      }
      return false;
    }
    else {
      for(int i = players.size() - 1; i > -1; i--) {
        if(!players.get(i).isDead) {
          if((y > players.get(i).y - players.get(i).pHeight - players.get(i).pHeight/3 && y < players.get(i).y + players.get(i).pHeight)) {
            if((x > players.get(i).x && x < players.get(i).x + players.get(i).pWidth)) {
              players.get(i).adjustLifes();
              return true;
            }
          }
        }
      }
    }
    return false;
  }
}
