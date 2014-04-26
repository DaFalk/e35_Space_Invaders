class Spawner {
  int enemyCols = 9;
  int enemyRows = 5;
  int baseScore = 50;
  
  Spawner() {
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
        enemies.add(new Enemy(col, row, baseScore - (baseScore/5)*row));
      }
    }
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
    spawnEnemies();
  }
}
