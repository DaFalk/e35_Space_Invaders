class Enemy {
  int eSize = 20;
  float x, y;
  int lastShot;
  int shotCooldown = 4000;
  int weaponType = 0;
  
  int enemyRows = 9;
  int enemyCols = 5;

  float stepX = eSize*1.5;
  float stepY = eSize*1.5;
  float dirX = 1;
  int moveInterval = 2000; 
  int lastMove;

  Enemy(float _x, float _y) {
    this.x = _x*stepX;
    this.y = _y*stepY + 100;
  }

  void update() {
    if(!gamePaused) {
      if(millis() - lastMove >= moveInterval) {
        x += stepX*dirX;
        checkCollision();
        lastMove = millis();
      }
    }
    drawEnemy();
  }

  boolean checkCollision() {
    if ((x+eSize/2 > width-eSize && dirX > 0) || (x + eSize/2 < eSize && dirX < 0)) {
      dirX *= -1;
      y += stepY;
      return true;
    }
    return false;
  }

  void drawEnemy() {
    noStroke();
    fill(156, 156, 156);
    ellipse(x , y, eSize, eSize);
  }

  void shoot() {
    if(millis() >= lastShot + shotCooldown) {
      int _i = floor(random(0, enemies.size()));
      Enemy _enemy = enemies.get(_i);
      Shot s = new Shot(_enemy.x, _enemy.y + _enemy.eSize, weaponType, 10);
      shots.add(s);
      lastShot = millis();
      shotCooldown = ceil(random(3, 6))*1000;
    }
  }
}

