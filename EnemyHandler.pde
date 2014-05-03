class EnemyHandler {
  int dirX;
  int eSize;
  float moveDist;
  int lastMove, nextMove;
  int lastShot, nextShot;
  boolean moveDown = false;
  
  EnemyHandler() {
    nextMove = 1200;
    nextShot = 3000;
    dirX = 1;
  }
  
  void update() {
    moveEnemies();
    shoot();
  }
  
  void moveEnemies() {
    if(!gamePaused) {
      if(millis() - lastMove >= nextMove) {
        if(!moveDown) {
          for(int i = enemies.size()-1; i > -1; i--) {
            enemies.get(i).x += moveDist*dirX;
            enemies.get(i).moveSwitch = !enemies.get(i).moveSwitch;
          }
        }
        else {
          for(int i = enemies.size()-1; i > -1; i--) {
            enemies.get(i).y += moveDist;
            enemies.get(i).moveSwitch = !enemies.get(i).moveSwitch;
          }
          dirX *= -1;
        }
        checkEnemiesCollision();
        lastMove = millis();
      }
    }
  }
  
  void checkEnemiesCollision() {
    for(int i = enemies.size()-1; i > -1; i--) {
      if ((enemies.get(i).x + eSize > width-eSize && dirX > 0) || (enemies.get(i).x - eSize < eSize && dirX < 0)) {
        moveDown = true;
        return;
      }
    }
    moveDown = false;
  }

  void shoot() {
    if(millis() >= lastShot + nextShot) {
      int _randomEnemy = floor(random(0, enemies.size()));
      Enemy _enemy = enemies.get(_randomEnemy);
      Shot s = new Shot(_enemy.x, _enemy.y + _enemy.eSize, 0, 10);
      shots.add(s);
      lastShot = millis();
    }
  }
  
  void reset() {
    enemies.clear();
    nextMove = 1200;
    nextShot = 3000;
    dirX = 1;
  }
}
