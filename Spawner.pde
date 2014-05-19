// This class controls everthing related to spawning game objects
// such as players, enemies, shots and powerups.
//

class Spawner {
  int enemyCols = 9;
  int enemyRows = 5;
  int blockSize = (int)dynamicValue(2);
  int enemySize;
  float enemyStepX;

  //timer variables for the enemyBoss function
  int time = millis();
  int wait = 15000; // wait for seconds. Used to time the boss spawn

  Spawner() {
    enemySize = blockSize*12;
    enemyStepX = (width-enemySize)/enemySize;  //The amount enemies move each move tick.
  }
  
  //Start game and spawn everything, amount of players depend on value passed in.
  void startGame(int _numPlayers) {
    spawnPlayers(_numPlayers);
    enemyHandler.reset();
    spawnEnemies();
    gameStarted = true;
    ground.spawnGround();
    ground.spawnCover();
  }
  
  //Player spawn and respawn.
  void spawnPlayers(int numPlayers) {
    for(int i = 0; i < numPlayers; i++) {
      players.add(new Player(width/(2+i) - ((width/2 - width/3)*(numPlayers-1))*(1-i) + (width/(2+i))*i));
    }
  }
  void respawnPlayer(Player player) {
    player.x = width/(2+players.indexOf(player)) - ((width/2 - width/3)*(players.size()-1))*(1-players.indexOf(player)) + (width/(2+players.indexOf(player)))*players.indexOf(player);
  }
  
  //Enemies spawn and respawn.
  void spawnEnemies() {
    //Set enemyHandler values for enemies size and move distance.
    enemyHandler.eSize = enemySize;
    enemyHandler.moveDist = enemyStepX/2;
    
    //Spawn enemies in a grid making their type dependent on spawn position.
    for(int row = 0; row < enemyRows; row++) {
      for(int col = 0; col < enemyCols; col++) {
        int _type = 3;  //Row 0 is type 3.
        if(row >= 1) {  //Row 1 and 2 are type 2.
          _type = 2;
          if(row >= 3) { _type = 1; }  //Row 3 and 4 are type 1.
        }
        //Set enemy spawn position.
        PVector _pos = new PVector(enemySize + col*enemyStepX, row*enemyStepX + dynamicValue(100));
        //Add enemy to enemies array list with the type, position and spawner blocksize.
        enemies.add(new Enemy(_type, _pos, blockSize));
      }
    }
  }
  void respawnEnemies() {
    if(!audioHandler.audioBank[6].isPlaying()) {
      enemyHandler.dirX = 1;  //Reset move direction.
      
      //Decrease enemy movement tick timer and shoot cooldown.
      if(enemyHandler.nextMove > 50) { enemyHandler.nextMove -= 45; }
      if(enemyHandler.shotTimer > 200) { enemyHandler.shotTimer -= 800; }
      
      //Spawn enemies.
      spawnEnemies();
      enemyHandler.respawnEnemies = false;
    }
  }
  
  //Spawn and respawn boss independent of enemy respawns.
  void spawnEnemyBoss() {
    //Spawn after a time period.
    if(millis() - time >= wait) { 
      Enemy e = new Enemy(10, new PVector(70, 70), blockSize);  //Initialize boss enemy (type 10).
      enemyHandler.boss = e;  //Store enemy as boss.
      enemies.add(e);
      enemyHandler.bossAlive = true;  //Indicate that a boss is alive. 
      enemyHandler.bossDirX = 1;  //reset move direction.
      time = millis(); 
    }
  }
  
  void spawnStartMenuEnemies() {
    //Spawn start menu enemies
    enemyHandler.reset();  //Clear enemy array lists and reset move and shot timer and direction.
    int _blockSize = blockSize*2;  //Double size.
    float _eOffset = _blockSize*18;
    //Spawn 5 of each regular enemy.
    for(int h = 4; h > -1; h--) {
      for(int i = 0; i < 3; i++) {
        PVector _pos = new PVector((width/8)*3 - _eOffset - _eOffset*(h-1), height/2 + _eOffset - _eOffset*i);
        Enemy enemy = new Enemy(1+i, _pos, _blockSize);
        enemies.add(enemy);
        //Fade enemies depending on index.
        enemy.eFill = color(255, 255 - h*48);
        enemy.setBlocksFill();
      }
    }
    
    //Spawn start menu boss individually.
    Enemy boss = new Enemy(10, new PVector(width - width/7, height/2), _blockSize);
    enemies.add(boss);
    boss.eFill = color(255);
    boss.setBlocksFill();
  }
  
  //Initialize a shot with position, type and owner index.
  void spawnShot(PVector _pos, int _type, int _owner) {
    Shot s = new Shot(_pos, _type, _owner);
    shots.add(s);
  }

  //Initialize a powerup with position and size.
  void spawnPowerUp(PVector _powerUpPos, float _size) {
    if (random(0, 100) > 90) {
      powerUps.add(new PowerUp(_powerUpPos, _size));
    }
  }
}

