/*
 MPGD: Exercise 35: Space Invaders
 Jimmie Gustafsson (jgus) & Troels Falkenberg (tfal)
 
This class manages enemy movement, collision, animation and shooting
 */

class EnemyHandler {
  int enemyDirX;  //The direction to move enemies (1 or -1).
  int bossDirX;  //The direction to move boss (1 or -1).
  int eWidth;
  float moveDist;  //The distance to move (set by the spawner when spawning enemies).
  int lastMove, nextMove;
  int lastShot, shotTimer, nextShot;
  int lastAliveAnim, lastDeadAnim, nextAnim;
  boolean moveDown = false;
  boolean respawnEnemies = false;
  boolean bossAlive = false;
  Enemy boss;

  EnemyHandler() {
    nextMove = 200;
    shotTimer = 5000;
    nextShot = shotTimer;
    nextAnim = nextMove;
    lastMove = millis();
    lastShot = millis();
    enemyDirX = 1;
    bossDirX = 1;
  }

  //Resets enemyhandler when called.
  void reset() {
    //Clear enemy arrays.
    enemies.clear();
    deadEnemies.clear();
    nextMove = 200;  //Initial nextMove value.
    shotTimer = 5000;  //Initial shot timer value.
    enemyDirX = 1;  //Initial direction.
  }

  void update() {
    //As long as there's enemies alive and game is unpaused check to move and shoot.
    if (!gamePaused) {
      if (enemies.size() > 0) {
        if (gameStarted) {
          moveEnemies();
          shoot();
        }
        //Animate alive enemies.
        lastAliveAnim = animate(enemies, lastAliveAnim);
        //Animate dead enimies(i.e. potential death projectiles).
        if (deadEnemies.size() > 0) { 
          lastDeadAnim = animate(deadEnemies, lastDeadAnim);
        }
      }
    }
    else {
      //Adjust "lastTick"'s to pause enemies.
      lastMove += millis() - lastMove;
      lastAliveAnim += millis() - lastAliveAnim;
      lastDeadAnim += millis() - lastDeadAnim;
    }

    //Check if enemies or boss should respawn.
    if (respawnEnemies) { 
      spawner.respawnEnemies();
    }
    if (!bossAlive) { 
      spawner.spawnEnemyBoss();
    }
  }

  void moveEnemies() {
    //Find boss and move it.
    for (int i = enemies.size()-1; i > -1; i--) {
      if (enemies.get(i) == boss) {
        enemies.get(i).moveEnemy((moveDist/4)*bossDirX, 0);
      }
    }

    //Enemy nextMove time depends on number of enemies alive.
    if (millis() - lastMove >= (nextMove/((spawner.enemyRows*spawner.enemyCols)/4))*enemies.size()) {
      if (!moveDown) {
        //Move enemies to the side except the boss.
        for (int i = enemies.size()-1; i > -1; i--) {
          if (enemies.get(i) != boss) {
            enemies.get(i).moveEnemy((moveDist/2)*enemyDirX, 0);
          }
        }
      }
      else {
        //Move enemies down except the boss.
        for (int i = enemies.size()-1; i > -1; i--) {
          if (enemies.get(i) != boss) {
            enemies.get(i).moveEnemy(0, moveDist*1.2);
          }
        }
        enemyDirX *= -1;  //Change enemy direction.
      }
      //Check if any enemy collides with the left and right bounds.
      checkEnemiesCollision();
      lastMove = millis();
    }
  }

  //Animate a given array of enemies.
  int animate(ArrayList<Enemy> _enemies, int _lastAnim) {
    int _nextAnim;
    //Check if the array is the alive enemies array.
    if (_enemies == enemies) { 
      //Animate speed of alive enemies is based on number of enemies left.
      _nextAnim = (nextAnim/((spawner.enemyRows*spawner.enemyCols)/4))*enemies.size();
    }
    else {  
      _nextAnim = nextAnim;
    };

    if (millis() - _lastAnim >= _nextAnim) {
      for (int i = _enemies.size()-1; i > -1; i--) {
        //If it is time to do an the animations, then animate each enemy.
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
      //Check if the enemy's next left and right position is within bounds.
      float nextLeftX = enemies.get(i).enemyPos.x - eWidth/2 - moveDist;
      float nextRightX = enemies.get(i).enemyPos.x + eWidth/2 + moveDist;

      //collision for non-boss type enemies.
      if (enemies.get(i) != boss) {
        if ((nextRightX > width && enemyDirX > 0) || (nextLeftX < 0 && enemyDirX < 0)) {
          //If the next move is not within bound then indicate that enemies should move down next.
          moveDown = true;
          return;
        }
      }
      else {
        //Enemy boss edge collision detection.
        if ((nextRightX > width*random(1.5, 2) && bossDirX > 0) || (nextLeftX  < -width* random(0.5, 1) && bossDirX < 0)) {
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
      //Spawn a shot with the enemy position, weapon type and "not-player" index.
      spawner.spawnShot(new PVector(_enemy.enemyPos.x, _enemy.enemyPos.y + _enemy.eHeight), 5, 10);
      lastShot = millis();
    }
  }
}

