class Spawner {
  Spawner() {
  }
  
  void spawnPlayers(int numPlayers) {
    for(int i = 0; i < numPlayers; i++) {
      players.add(new Player(width/(2+i) - ((width/2 - width/3)*(numPlayers-1))*(1-i) + (width/(2+i))*i));
    }
  }

  void spawnEnemies(int eSize) {
    int enemyRows = 9;
    int enemyCols = 5;
    for(int col = 0; col < enemyCols; col++) {
      for(int row = 0; row < enemyRows; row++) {
        enemies.add(new Enemy(row, col));
      }
    }
  }
  
  void respawn(Player player) {
    player.x = width/(2+players.indexOf(player)) - ((width/2 - width/3)*(players.size()-1))*(1-players.indexOf(player)) + (width/(2+players.indexOf(player)))*players.indexOf(player);
  }
}
