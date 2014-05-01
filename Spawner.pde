class Spawner {
  int enemyCols = 9;
  int enemyRows = 5;
  int eSize = 20;
  int dirX;
  float stepX;
  float stepY;
  int moveInterval = 500; 
  int lastMove;
  
  Spawner() {
    stepX = eSize*1.5;
    stepY = 0;
    dirX = 1;
  }
  
  void startGame(int _numPlayers) {
    spawnPlayers(_numPlayers);
    spawnEnemies();
    gameStarted = true;
  }
  
  void spawnPlayers(int numPlayers) {
    for(int i = 0; i < numPlayers; i++) {
      players.add(new Player(width/(2+i) - ((width/2 - width/3)*(numPlayers-1))*(1-i) + (width/(2+i))*i));
    }
  }

  void spawnEnemies() {
    for(int row = 0; row < enemyRows; row++) {
      for(int col = 0; col < enemyCols; col++) {
        int _type = 3;
        if(row >= 1) {
          _type = 2;
          if(row >= 3) {
            _type = 1;
          }
        }
        enemies.add(new Enemy(_type, col*stepX, row*stepX + 100, eSize));
      }
    }
  }
  void moveEnemiesX() {
    if(!gamePaused) {
      if(millis() - lastMove >= moveInterval) {
        for(int i = enemies.size()-1; i > -1; i--) {
          lastMove = millis();
          enemies.get(i).x += stepX*dirX;
          enemies.get(i).moveSwitch = !enemies.get(i).moveSwitch;
        }
      }
    }
  }
  void moveEnemiesY() {
    for(int i = enemies.size()-1; i > -1; i--) {
      enemies.get(i).y += stepX;
    }
  }
  boolean checkEnemiesCollision() {
    for(int i = enemies.size()-1; i > -1; i--) {
      if ((enemies.get(i).x + eSize/2 >= width-eSize && spawner.dirX > 0) || (enemies.get(i).x - eSize/2 <= eSize && spawner.dirX < 0)) {
        dirX *= -1;
        moveEnemiesY();
        return true;
      }
    }
    return false;
  }
  
  void spawnPowerUp(float _x, float _y, int _size) {
    if(random(0, 100) > 80) {
      powerUps.add(new PowerUp(_x, _y, _size));
    }
  }
  
  void respawnPlayer(Player player) {
    player.x = width/(2+players.indexOf(player)) - ((width/2 - width/3)*(players.size()-1))*(1-players.indexOf(player)) + (width/(2+players.indexOf(player)))*players.indexOf(player);
  }
  
  void respawnEnemies() {
    enemies.clear();
    dirX = 1;
    spawnEnemies();
  }
}
