//
//
// Accesse classes: Enemy, Shot

class EnemyHandler {
  int dirX;
  int eSize;
  float moveDist;
  int lastMove, nextMove;
  int lastShot, shotTimer, nextShot;
  boolean moveDown = false;
  boolean respawnEnemies = false;
  ArrayList<Enemy> deadEnemies = new ArrayList<Enemy>();
  
  EnemyHandler() {
    nextMove = 400;
    shotTimer = 2000;
    nextShot = shotTimer;
    lastMove = millis();
    lastShot = millis();
    dirX = 1;
  }
  
  void update() {
    if(enemies.size() > 0) {
      moveEnemies();
      shoot();
    }
    for(int i = deadEnemies.size()-1; i > -1; i--) {
      deadEnemies.get(i).update();
    }
    if(respawnEnemies) { spawner.respawnEnemies(); }
  }
  
  void moveEnemies() {
    if(!gamePaused) {
      if(millis() - lastMove >= nextMove) {
        if(!moveDown) {
          for(int i = enemies.size()-1; i > -1; i--) {
            if(!enemies.get(i).isDead) {
              enemies.get(i).moveEnemy((moveDist/2)*dirX, 0);
            }
          }
        }
        else {
          for(int i = enemies.size()-1; i > -1; i--) {
            if(!enemies.get(i).isDead) {
              enemies.get(i).moveEnemy(0, moveDist/2);
            }
          }
          dirX *= -1;
        }
        checkEnemiesCollision();
        lastMove = millis() + millis()-lastMove;
      }
    }
  }
  
  void checkEnemiesCollision() {
    for(int i = enemies.size()-1; i > -1; i--) {
      float nextLeftX = enemies.get(i).x - eSize/2 - moveDist;
      float nextRightX = enemies.get(i).x + eSize/2 + moveDist;
      if((nextRightX > width && dirX > 0) || (nextLeftX < 0 && dirX < 0)) {
        moveDown = true;
        return;
      }
    }
    moveDown = false;
  }

  void shoot() {
    if(millis() >= lastShot + nextShot) {
      int _randomEnemy = floor(random(0, enemies.size()));
      nextShot = ceil(random(500, shotTimer));
      Enemy _enemy = enemies.get(_randomEnemy);
      if(!_enemy.isDead) {
        Shot s = new Shot(new PVector(_enemy.x, _enemy.y + _enemy.eHeight), 5, 10);
        shots.add(s);
        lastShot = millis();
      }
    }
  }
  
  void reset() {
    enemies.clear();
    nextMove = 400;
    shotTimer = 2000;
    dirX = 1;
  }
}
