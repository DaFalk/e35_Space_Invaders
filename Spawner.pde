class Spawner {
  int enemyCols = 9;
  int enemyRows = 5;
  int blockSize = (int)dynamicValue(2);
  int enemySize;
  float enemyStepX;
  boolean respawnEnemies = false;
  boolean bossAlive = false;

  //timer variables for the enemyBoss function
  int time = millis();
  int wait = 15000; // wait for seconds. Used to time the boss spawn

  Spawner() {
    enemySize = blockSize*12;
    enemyStepX = (width-enemySize)/enemySize;
  }

  void startGame(int _numPlayers) {
    spawnPlayers(_numPlayers);
    enemyHandler.reset();
    spawnEnemies();
    gameStarted = true;
    ground.spawnGround();
    ground.spawnCover();
  }

  void spawnPlayers(int numPlayers) {
    for (int i = 0; i < numPlayers; i++) {
      players.add(new Player(width/(2+i) - ((width/2 - width/3)*(numPlayers-1))*(1-i) + (width/(2+i))*i));
    }
  }

  void spawnEnemies() {
    enemyHandler.eSize = enemySize;
    enemyHandler.moveDist = enemyStepX/2;

    for (int row = 0; row < enemyRows; row++) {
      for (int col = 0; col < enemyCols; col++) {
        int _type = 3;
        if (row >= 1) {
          _type = 2;
          if (row >= 3) { _type = 1; }
        }
        PVector _pos = new PVector(enemySize/2 + col*enemyStepX, row*enemyStepX + dynamicValue(100));
        enemies.add(new Enemy(_type, _pos, blockSize));
      }
    }
  }
  void spawnEnemyBoss() {
    if (millis() - time >= wait && !bossAlive) { 
      Enemy e = new Enemy(10, new PVector(70, 70), 2);
      enemyHandler.boss = e;
      enemies.add(e);
      bossAlive = true;
      enemyHandler.bossDirX = 1;
      time = millis(); 
    }
  }

  void spawnPowerUp(PVector _powerUpPos, float _size) {
    if (random(0, 100) > 90) {
      powerUps.add(new PowerUp(_powerUpPos, _size));
    }
  }

  void respawnPlayer(Player player) {
    player.x = width/(2+players.indexOf(player)) - ((width/2 - width/3)*(players.size()-1))*(1-players.indexOf(player)) + (width/(2+players.indexOf(player)))*players.indexOf(player);
  }

  void respawnEnemies() {
    if (!audioHandler.audioBank[6].isPlaying()) {
      enemyHandler.dirX = 1;
      if(enemyHandler.nextMove > 50) { enemyHandler.nextMove -= 45; }
      if(enemyHandler.shotTimer > 200) { enemyHandler.shotTimer -= 400; }
      spawnEnemies();
      enemyHandler.respawnEnemies = false;
    }
  }
}

