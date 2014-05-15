// This class manages enemy movement, collision, animation and shooting
//
// Accesse classes: Enemy, Shot

class EnemyHandler {
  int dirX;  //Determine direction to move(dirX is either 1 or -1).
  int bossDirX;
  int eSize;
  float moveDist;  //The distance to move (set by the spawner when spawning enemies).
  int lastMove, nextMove;
  int lastShot, shotTimer, nextShot;
  int lastAliveAnim, lastDeadAnim, nextAnim;
  boolean moveDown = false;
  boolean respawnEnemies = false;
  Enemy boss;

  EnemyHandler() {
    nextMove = 400;
    shotTimer = 5000;
    nextShot = shotTimer;
    nextAnim = nextMove;
    lastMove = millis();
    lastShot = millis();
    dirX = 1;
    bossDirX = 1;
  }

  //Resets enemyhandler when called.
  void reset() {
    enemies.clear();
    deadEnemies.clear();
    nextMove = 400;  //Initial nextMove value.
    shotTimer = 5000;  //Initial shot timer value.
    dirX = 1;  //Initial direction.
  }

  void update() {
    if (!gamePaused) {
      if (enemies.size() > 0) {
        if (gameStarted) {
          moveEnemies();
          shoot();
        }
        lastAliveAnim = animate(enemies, lastAliveAnim);  //Animate alive enemies.
        if (deadEnemies.size() > 0) { 
          lastDeadAnim = animate(deadEnemies, lastDeadAnim);
        }  //Animate dead enimies(i.e. potential death projectiles).
      }
    }
    else {
      //Adjust "lastTick"'s to pause enemies.
      lastMove += millis() - lastMove;
      lastAliveAnim += millis() - lastAliveAnim;
      lastDeadAnim += millis() - lastDeadAnim;
    }

    if (respawnEnemies) { 
      spawner.respawnEnemies();
    }
  }

  void moveEnemies() {
    
    for (int i = enemies.size()-1; i > -1; i--) {
      if (enemies.get(i) == boss) {
        enemies.get(i).moveEnemy((moveDist/2)*bossDirX, 0);
      }
    }
    
    //Enemy nextMove time depends on number of enemies alive.
    if (millis() - lastMove >= (nextMove/((spawner.enemyRows*spawner.enemyCols)/4))*enemies.size()) {
      if (!moveDown) {  //Move enemies to the side.
        for (int i = enemies.size()-1; i > -1; i--) {
          if (enemies.get(i) != boss && !enemies.get(i).isDead) {
            enemies.get(i).moveEnemy((moveDist/2)*dirX, 0);
          }
        }
      }
      else {
        //Move enemies down.
        for (int i = enemies.size()-1; i > -1; i--) {
          if (enemies.get(i) != boss && !enemies.get(i).isDead) {
            enemies.get(i).moveEnemy(0, moveDist);
          }
        }
        dirX *= -1;  //Change direction.
      }
      checkEnemiesCollision();
      lastMove = millis();
    }
  }

  //Animate a given array of enemies.
  int animate(ArrayList<Enemy> _enemies, int _lastAnim) {
    int _nextAnim;
    if (_enemies == enemies) { 
      _nextAnim = (nextAnim/((spawner.enemyRows*spawner.enemyCols)/4))*enemies.size();
    }
    else { 
      _nextAnim = nextAnim;
    }; 
    if (millis() - _lastAnim >= _nextAnim) {
      for (int i = _enemies.size()-1; i > -1; i--) {
        if (_enemies.get(i).doAnimation) {
          _enemies.get(i).animateEnemy();
        }
      }
      return millis();
    }
    return _lastAnim;
  }

  //Collision detection
  void checkEnemiesCollision() {
    
    for (int i = enemies.size()-1; i > -1; i--) {
      if (enemies.get(i) != boss){
      //Check if the enemy's next left and right position is within bounds.
      float nextLeftX = enemies.get(i).enemyPos.x - eSize/2 - moveDist;
      float nextRightX = enemies.get(i).enemyPos.x + eSize/2 + moveDist;
      if ((nextRightX > width && dirX > 0) || (nextLeftX < 0 && dirX < 0)) {
        //If the next move is not within bound then indicate that enemies should move down next.
        moveDown = true;
        return;
      }
    }
  }
  for (int i = enemies.size()-1; i > -1; i--) {
    if  (enemies.get(i) == boss){
      if (enemies.get(i).enemyPos.x <= 0 || enemies.get(i).enemyPos.x >= width){
        bossDirX *= -1;
    }
    }
  }
    moveDown = false;
  }
  
  
  //Random enemy shot
  void shoot() {
    if (millis() >= lastShot + nextShot) {
      int _randomEnemy = floor(random(0, enemies.size()));  //Chose a random enemy index.
      nextShot = ceil(random(shotTimer/3, shotTimer));  //Chose random nextShot from limited inteval.
      Enemy _enemy = enemies.get(_randomEnemy);  //Choose the enemy at the random index as the shooter.
      //Trigger a shot.
      Shot s = new Shot(new PVector(_enemy.enemyPos.x, _enemy.enemyPos.y + _enemy.eHeight), 5, 10);
      shots.add(s);
      lastShot = millis();
    }
  }
}

