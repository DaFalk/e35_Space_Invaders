//
//
// Accesse classes: Enemy, Shot

class EnemyHandler {
  int dirX;
  int eSize;
  float moveDist;
  int lastMove, nextMove;
  int lastShot, shotTimer, nextShot;
  int lastAliveAnim, lastDeadAnim, nextAnim;
  boolean moveDown = false;
  boolean respawnEnemies = false;

  EnemyHandler() {
    nextMove = 400;
    shotTimer = 5000;
    nextShot = shotTimer;
    nextAnim = nextMove;
    lastMove = millis();
    lastShot = millis();
    dirX = 1;
  }

  void update() {
    if(!gamePaused) {
      if (enemies.size() > 0) {
        if(gameStarted) {
          moveEnemies();
          shoot();
        }
        lastAliveAnim = animate(enemies, lastAliveAnim);
        if(deadEnemies.size() > 0) { lastDeadAnim = animate(deadEnemies, lastDeadAnim); }
      }
    }
    else {
      lastMove += millis() - lastMove;
      lastAliveAnim += millis() - lastAliveAnim;
      lastDeadAnim += millis() - lastDeadAnim;
    }
    
    if (respawnEnemies) { 
      spawner.respawnEnemies();
    }
  }

  void moveEnemies() {
    //Enemy nextMove time depends on number of enemies alive.
    if (millis() - lastMove >= (nextMove/((spawner.enemyRows*spawner.enemyCols)/4))*enemies.size()) {
      if (!moveDown) {  //Move enemies to the side.
        for (int i = enemies.size()-1; i > -1; i--) {
          if (!enemies.get(i).isDead) {
            enemies.get(i).moveEnemy((moveDist/2)*dirX, 0);
          }
        }
      }
      else {  //Move enemies down.
        for (int i = enemies.size()-1; i > -1; i--) {
          if (!enemies.get(i).isDead) {
            enemies.get(i).moveEnemy(0, moveDist);
          }
        }
        dirX *= -1;
      }
      checkEnemiesCollision();
      lastMove = millis();
    }
  }
  
  int animate(ArrayList<Enemy> _enemies, int _lastAnim) {
    int _nextAnim;
    if(_enemies == enemies) { _nextAnim = (nextAnim/((spawner.enemyRows*spawner.enemyCols)/4))*enemies.size(); }
    else { _nextAnim = nextAnim; }; 
    if(millis() - _lastAnim >= _nextAnim) {
      for(int i = _enemies.size()-1; i > -1; i--) {
        _enemies.get(i).animateEnemy();
      }
      return millis();
    }
    return _lastAnim;
  }

//Collision detection
  void checkEnemiesCollision() {
    for (int i = enemies.size()-1; i > -1; i--) {
      float nextLeftX = enemies.get(i).enemyPos.x - eSize/2 - moveDist;
      float nextRightX = enemies.get(i).enemyPos.x + eSize/2 + moveDist;
      if ((nextRightX > width && dirX > 0) || (nextLeftX < 0 && dirX < 0)) {
        moveDown = true;
        return;
      }
    }
    moveDown = false;
  }

//Random enemy shot
  void shoot() {
    if (millis() >= lastShot + nextShot) {
      int _randomEnemy = floor(random(0, enemies.size()));
      nextShot = ceil(random(shotTimer/3, shotTimer));
      Enemy _enemy = enemies.get(_randomEnemy);
      if (!_enemy.isDead) {
        Shot s = new Shot(new PVector(_enemy.enemyPos.x, _enemy.enemyPos.y + _enemy.eHeight), 5, 10);
        shots.add(s);
        lastShot = millis();
      }
    }
  }
  
//Rest
  void reset() {
    enemies.clear();
    deadEnemies.clear();
    nextMove = 400;
    shotTimer = 5000;
    dirX = 1;
  }
}

