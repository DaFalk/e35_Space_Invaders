class Spawner {
  int enemyCols = 9;
  int enemyRows = 5;
  int enemyDirX;
  int enemySize;
  float enemyStepX;
  int enemyLastMove, enemyNextMove;
  int enemyNextShot;
  boolean enemyMoveDown = false;
  
  Spawner() {
    enemyDirX = 1;
  }
  
  void startGame(int _numPlayers) {
    spawnPlayers(_numPlayers);
    enemies.clear();
    enemyNextMove = 1200;
    enemyNextShot = 3000;
    spawnEnemies();
    gameStarted = true;
  }
  
  void spawnPlayers(int numPlayers) {
    for(int i = 0; i < numPlayers; i++) {
      players.add(new Player(width/(2+i) - ((width/2 - width/3)*(numPlayers-1))*(1-i) + (width/(2+i))*i));
    }
  }

  void spawnEnemies() {
    int blockSize = 2;
    enemySize = blockSize*12;
    enemyStepX = width/enemySize;
    for(int row = 0; row < enemyRows; row++) {
      for(int col = 0; col < enemyCols; col++) {
        int _type = 3;
        if(row >= 1) {
          _type = 2;
          if(row >= 3) { _type = 1; }
        }
        enemies.add(new Enemy(_type, (1+col)*enemyStepX, row*enemyStepX + 100, blockSize));
      }
    }
  }
  
  void spawnPowerUp(float _x, float _y, float _size) {
    if(random(0, 100) > 85) {
      powerUps.add(new PowerUp(_x, _y, _size));
    }
  }
  
  void respawnPlayer(Player player) {
    player.x = width/(2+players.indexOf(player)) - ((width/2 - width/3)*(players.size()-1))*(1-players.indexOf(player)) + (width/(2+players.indexOf(player)))*players.indexOf(player);
  }
  
  void respawnEnemies() {
    enemies.clear();
    enemyDirX = 1;
    enemyNextMove -= 100;
    enemyNextShot -= 200;
    spawnEnemies();
  }
  
  void moveEnemies() {
    if(!gamePaused) {
      if(millis() - enemyLastMove >= enemyNextMove) {
        if(!enemyMoveDown) {
          for(int i = enemies.size()-1; i > -1; i--) {
            enemies.get(i).x += enemyStepX*enemyDirX;
            enemies.get(i).moveSwitch = !enemies.get(i).moveSwitch;
          }
        }
        else {
          for(int i = enemies.size()-1; i > -1; i--) {
            enemies.get(i).y += enemyStepX;
            enemies.get(i).moveSwitch = !enemies.get(i).moveSwitch;
          }
          enemyDirX *= -1;
        }
        checkEnemiesCollision();
        enemyLastMove = millis();
      }
    }
  }
  
  void checkEnemiesCollision() {
    for(int i = enemies.size()-1; i > -1; i--) {
      if ((enemies.get(i).x + enemySize > width-enemySize && enemyDirX > 0) || (enemies.get(i).x - enemySize < enemySize && enemyDirX < 0)) {
        enemyMoveDown = true;
        return;
      }
    }
    enemyMoveDown = false;
  }
}
