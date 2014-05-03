class Spawner {
  int enemyCols = 9;
  int enemyRows = 5;
  int blockSize = 2;
  int enemySize;
  float enemyStepX;
  
  Spawner() {
    enemySize = blockSize*12;
    enemyStepX = width/enemySize;
  }
  
  void startGame(int _numPlayers) {
    spawnPlayers(_numPlayers);
    enemyHandler.reset();
    spawnEnemies();
    gameStarted = true;
  }
  
  void spawnPlayers(int numPlayers) {
    for(int i = 0; i < numPlayers; i++) {
      players.add(new Player(width/(2+i) - ((width/2 - width/3)*(numPlayers-1))*(1-i) + (width/(2+i))*i));
    }
  }

  void spawnEnemies() {
    enemyHandler.eSize = enemySize;
    enemyHandler.moveDist = enemyStepX;
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
    enemyHandler.dirX = 1;
    enemyHandler.nextMove -= 100;
    enemyHandler.nextShot -= 200;
    spawnEnemies();
  }
}
