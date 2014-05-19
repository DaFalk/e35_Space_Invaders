// This class draws different types of enemies out of blocks and controls their movement and collision(when dead and projectile).
// It also handles what happens when enemies are damaged and destroyed and which sounds the enemies play.
//
// Accesse classes: Block, spawner, menUI, audioHandler, enemyHandler, players[], enemies[]

class Enemy {
  ArrayList<Block> blocks;
  PVector enemyPos;
  float eSize, eHeight;
  int half;  //Half the size of the blocks arraylist (to be able to draw half the blocks and mirror them).
  int blockSize;
  int type, lifes, points;
  int moveSwitch = 1;
  int blockDir = 1;
  int fadeStart = 0;
  float timeElapsed = 0;
  float fadeAmount = 0;
  color eFill = color(255);
  boolean doAnimation = true;
  boolean destroy = false;
  boolean isDead = false;
  boolean isProjectile = false;
  PVector lowestPoint = new PVector(0, 0);

  Enemy(int _type, PVector _pos, int _blockSize) {
    type = _type;
    points = type*5;
    lifes = 6;
    enemyPos = _pos;
    blocks = new ArrayList<Block>();
    blockSize = _blockSize;
    eSize = 6*blockSize;
    eHeight = 4*blockSize;
    
    half = ceil(setArrayLength()/2);
    for(int i = 0; i < setArrayLength(); i ++) {
      blocks.add(new Block(enemyPos, blockSize));
      blocks.get(i).bFill = eFill;
      blocks.get(i).owner = this;
    }
    setBlockPositions();
  }

  //Draw enemy type using blocks and display the blocks
  void update() {
    for(int i = blocks.size()-1; i > -1; i--) {
      blocks.get(i).display();  //Display enemy blocks.
      if(isDead) {  //If dead calculate lowest point from the block positions.
        if(blocks.get(i).blockPos.y > lowestPoint.y) {
          lowestPoint = blocks.get(i).blockPos;
        }
      }
    }
    if(fadeStart > 0) { fade(); }  //Fade when fade amount is set.
    if(isDead) {
      if(checkBlockCollision() || destroy) { deadEnemies.remove(this); }  //Remove enemy death projectile on impact.
    }
  }

  //Move enemy in formation.
  void moveEnemy(float _amountX, float _amountY) {
    //Add move distance to enemy position.
    enemyPos.x += _amountX;
    enemyPos.y += _amountY;
    //Do the same for all blocks.
    for(int i = blocks.size()-1; i > -1; i--) {
      blocks.get(i).blockPos.x += _amountX;
      blocks.get(i).blockPos.y += _amountY;
    }
    checkCollision();
  }

  //Returns the amount of blocks used to draw the different enemies.
  int setArrayLength() {
    if(type == 1) { return 62; }
    else if(type == 2) { return 48; }
    else if(type == 3) { return 36; }
    else if(type == 10) { return 64; }  //Boss
    else { return 0; }
  }
  
  //Update blocks fill to match enemy color.
  void setBlocksFill() {
    for(int i = 0; i < setArrayLength(); i ++) {
      blocks.get(i).bFill = eFill;
    }
  }
  
  //Switches specific blocks between two positions based on a move switch.
  void animateEnemy() {
    switch(type) {
      case(1):
      for(int i = 0; i < 2; i++) {
        int flip = 1 - i*2;
        blocks.get(15 + half*i).blockPos.y += blockSize*moveSwitch;
        blocks.get(21 + half*i).blockPos.x += ((blockSize*3)*flip)*moveSwitch;
        blocks.get(21 + half*i).blockPos.y -= blockSize*moveSwitch;
        blocks.get(26 + half*i).blockPos.y -= blockSize*moveSwitch;
        blocks.get(30 + half*i).blockPos.x -= ((blockSize*2)*flip)*moveSwitch;
      }
      break;

      case(2):
      for(int i = 0; i < 2; i++) {
        int flip = 1 - i*2;
        int _half = half - 2;
        blocks.get(4 + _half*i).blockPos.x -= (blockSize*3)*flip*moveSwitch;
        blocks.get(4 + _half*i).blockPos.y += (blockSize*2)*moveSwitch;
        blocks.get(13 + _half*i).blockPos.x -= (blockSize*2)*flip*moveSwitch;
        blocks.get(23 + _half*i).blockPos.y += (blockSize*3)*moveSwitch;
        blocks.get(24 + _half*i).blockPos.y += (blockSize*3)*moveSwitch;
        blocks.get(25 + _half*i).blockPos.x -= (blockSize*2)*flip*moveSwitch;
        blocks.get(25 + _half*i).blockPos.y -= blockSize*moveSwitch;
      }
      break;

      case(3):
      for(int i = 0; i < 2; i++) {
        int flip = 1 - i*2;
        blocks.get(5 + half*i).blockPos.y -= blockSize*moveSwitch;
        blocks.get(9 + half*i).blockPos.x += blockSize*flip*moveSwitch;
        blocks.get(10 + half*i).blockPos.x += blockSize*flip*moveSwitch;
        blocks.get(14 + half*i).blockPos.y += blockSize*moveSwitch;
        blocks.get(17 + half*i).blockPos.y -= blockSize*moveSwitch;
      }
      break;
    }
    moveSwitch *= -1;  //Switch.
  }

  void damageEnemy(Shot _shot) {
    //Deal shot damage to enemy and adjust enemy color according to lifes left.
    if(lifes > 0) {
      int _shotDamage = _shot.damage; 
      if(this != _shot.target && _shot.type == 3) { 
        _shotDamage = _shot.damage/2;
      }
      lifes -= _shotDamage;  //Deal damage to lifes.
      
      //If enemy is still alive then adjust the enemy color and blocks fill.
      if(lifes > 0) {
        eFill = color(255, 51*(lifes-1), 51*(lifes-1), 255 - fadeAmount);
        setBlocksFill();
      }
    }

    //Kill enemy if lifes goes below zero.
    if(lifes <= 0 && !isDead) {
      isDead = true;
      if(this == enemyHandler.boss ){
        enemyHandler.bossAlive = false;
        spawner.time = millis();
      }
      audioHandler.playSFX(2);

      //Check if enemy should spawn a powerup.
      spawner.spawnPowerUp(new PVector(enemyPos.x, enemyPos.y), (float)eSize);
      //Adjust player score and initialize floating points.
      menUI.addFloatingText(players.get(_shot.owner), enemyPos, nf(points, 0));

      //Set blocks deathPos to initialize their behaviour.
      //Randomly roll how to behave. 75 and above creates projectile from enemy and below explodes enemy.
      if(random(0, 100) > 75) {
        blockDir = -1;
        isProjectile = true;
      }
      else { doAnimation = false; }  //Projectiles are still animated.
      //Pass information to blocks.
      for(int i = blocks.size()-1; i > -1; i--) {
        blocks.get(i).blockDir = blockDir;
        blocks.get(i).deathPos = new PVector(enemyPos.x, enemyPos.y);
        blocks.get(i).lastMove = millis();
      }
      
      respawnCheck();

      //Add to new arraylist and remove from the old (to avoid interfering with shot targetting  and animation).
      deadEnemies.add(this);
      enemies.remove(this);
      //Start fading by raising fadeStart above 0.
      fadeStart = millis();
    }
  }
  
  void respawnCheck() {
    //Respawn enemies if this enemy was the last.
    if((enemies.size() == 1 && (enemyHandler.boss == null || enemyHandler.boss.isDead)) || (enemies.size() == 2 && enemyHandler.boss != null && !enemyHandler.boss.isDead)) {
      audioHandler.playSFX(6);
      enemyHandler.respawnEnemies = true;
    }
  }
  
  void checkCollision() {
    //Check if enemy collides with a cover.
    if(enemyPos.y + eHeight >= ground.coverY) {
      for(int i = 1; i < 5; i++) {
        if(collisionCheck(enemyPos, eSize, eHeight, new PVector((width/5)*i, ground.coverY + ground.coverHeight/2), ground.coverWidth/2, ground.coverHeight/2)) {
          for(int j = ground.coverBlocks.size()-1; j > -1; j--) {
            //Check if enemy collides with any ground blocks that isn't already broken.
            if(collisionCheck(ground.coverBlocks.get(j).blockPos, blockSize, blockSize, enemyPos, eSize, eHeight) && !ground.groundBlocks.get(j).broken) {
              ground.groundBlocks.get(j).broken = true;
              ground.damageGround(ground.coverBlocks, enemyPos, eSize*3, 100);
              enemies.remove(this);
              respawnCheck();
            }
          }
        }
      }
    }
    
    if(enemyPos.y > ground.coverY + ground.coverHeight) {
      for(int i = players.size()-1; i > -1; i--) {
        if(collisionCheck(enemyPos, eSize, eHeight, new PVector(players.get(i).x, players.get(i).y), players.get(i).pWidth/2, players.get(i).pHeight)) {
          players.get(i).adjustLifes();
          enemies.remove(this);
          respawnCheck();
        }
      }
    }
    
    //Check if enemy collides with the ground.
    if(enemyPos.y + eHeight >= ground.groundY) {
      //Damage ground.
      if(collisionCheck(enemyPos, eSize, eHeight, new PVector(width/2, ground.groundY + ground.groundHeight/2), width/2, ground.groundHeight/2)) {
        for(int i = ground.groundBlocks.size()-1; i > -1; i--) {
          //Check if enemy collides with any ground blocks that isn't already broken.
          if(collisionCheck(ground.groundBlocks.get(i).blockPos, blockSize, blockSize, enemyPos, eSize, eHeight) && !ground.groundBlocks.get(i).broken) {
            ground.groundBlocks.get(i).broken = true;
            ground.damageGround(ground.groundBlocks, enemyPos, eSize*4, 100);
            enemies.remove(this);
            respawnCheck();
          }
        }
        //Subtract lifes from both players.
        for(int i = players.size()-1; i > -1; i--) {
          if(players.get(i).lifes > 0) { players.get(i).adjustLifes(); }
        }
      }
    }
    
  }

  //Returns true if there was a collision.
  boolean checkBlockCollision() {
    //Check if enemy death projectile collides with a player
    for(int i = players.size() - 1; i > -1; i--) {
      Player _player = players.get(i);
      if(!_player.isDead) {  //Only check if the player is alive.
        if(collisionCheck(lowestPoint, blockSize/2, blockSize/2, new PVector(_player.x, _player.y), _player.pWidth/2, _player.pHeight)) {
          //Deal damage or remove shield if player has it.
          if(!_player.hasShield) { _player.adjustLifes(); }
          else { _player.hasShield = false; }
          return true;
        }
      }
    }
    
    //Check if enemy death projectile collides with the ground.
    if(lowestPoint.y > ground.groundY) {
      for(int j = ground.groundBlocks.size()-1; j > -1; j--) {
        if(collisionCheck(lowestPoint, blockSize/2, blockSize/2, ground.groundBlocks.get(j).blockPos, 4, 4)) {
          ground.damageGround(ground.groundBlocks, lowestPoint, ground.blockSize*3, 50);  //Call damage ground and pass in impact position.
          return true;
        }
      }
    }
    
    //Check if enemy death projectile collides with a cover.
    for(int c = 1; c < 5; c++) {
      if(collisionCheck(lowestPoint, blockSize/2, blockSize/2, new PVector((width/5)*c, ground.coverY + ground.coverHeight/2), ground.coverWidth/2, ground.coverHeight/2)) {
        for(int j = ground.coverBlocks.size()-1; j > -1; j--) {
          if(collisionCheck(lowestPoint, blockSize/2, blockSize/2, ground.coverBlocks.get(j).blockPos, 4, 4)) {
            ground.damageGround(ground.coverBlocks, lowestPoint, ground.blockSize*3, 75);
            return true;
          }
        }
      }
    }
    
    //No collision
    return false;
  }

  void fade() {
    timeElapsed += timeFix(1, fadeStart);
    //Fade out and to black if enemy explodes on death.
    if (blockDir > 0) {
      if (timeElapsed > 500) { timeElapsed = 500; }
      color curEnemyColor = lerpColor(eFill, color(0), timeElapsed/500);  //Fade to white in half a second.
      eFill = curEnemyColor;
      setBlocksFill();
      fadeAmount += timeFix(1, fadeStart);
      if (fadeAmount > 255) { deadEnemies.remove(this); }
      for (int i = blocks.size()-1; i > -1; i--) {
        blocks.get(i).currentAlpha -= fadeAmount;
      }
    }
    else {  //or fade to white if enemy implodes on death.
      if (timeElapsed > 500) { timeElapsed = 500; }
      color curEnemyColor = lerpColor(eFill, color(255), timeElapsed/500);  //Fade to white in half a second.
      eFill = curEnemyColor;
      setBlocksFill();
    }
  }

  //Reposition half of enemies blocks and then mirrors their positions.
  void setBlockPositions() {
    int flip;
    float _x;
    switch(type) {
      case(1):
      for(int i = 0; i < 2; i++) {
        flip = 1 - i*2;
        _x = enemyPos.x + (blockSize/2)*flip;
        for(int j = 0; j < 5; j++) {
          blocks.get(j + half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*3.5 + blockSize*j);
        }
        blocks.get(5 + half*i).blockPos = new PVector(_x, enemyPos.y + blockSize*2.5);
        _x = enemyPos.x + (blockSize*1.5)*flip;
        blocks.get(6 + half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*3.5);
        blocks.get(7 + half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*2.5);
        blocks.get(8 + half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*1.5);
        blocks.get(9 + half*i).blockPos = new PVector(_x, enemyPos.y + blockSize/2);
        blocks.get(10 + half*i).blockPos = new PVector(_x, enemyPos.y + blockSize*1.5);
        _x = enemyPos.x + (blockSize*2.5)*flip;
        blocks.get(11 + half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*2.5);
        blocks.get(12 + half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*1.5);
        blocks.get(13 + half*i).blockPos = new PVector(_x, enemyPos.y + blockSize*0.5);
        blocks.get(14 + half*i).blockPos = new PVector(_x, enemyPos.y + blockSize*1.5);
        _x = enemyPos.x + (blockSize*3.5)*flip;
        blocks.get(15 + half*i).blockPos = new PVector(_x - blockSize*flip, enemyPos.y + blockSize*2.5);
        for(int j = 16; j < 20; j++) {
          blocks.get(j + half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*2.5 + blockSize*(j-16));
        }
        blocks.get(20 + half*i).blockPos = new PVector(_x, enemyPos.y + blockSize*2.5);
        blocks.get(21 + half*i).blockPos = new PVector(_x - (blockSize*3)*flip, enemyPos.y + blockSize*2.5);
        _x = enemyPos.x + (blockSize*4.5)*flip;
        for(int j = 22; j < 26; j++) {
          blocks.get(j + half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*2.5 + blockSize*(j-22));
        }
        _x = enemyPos.x + (blockSize*5.5)*flip;
        blocks.get(26 + half*i).blockPos = new PVector(_x - (blockSize*1)*flip, enemyPos.y + blockSize*3.5);
        blocks.get(27 + half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*1.5);
        blocks.get(28 + half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*0.5);
        blocks.get(29 + half*i).blockPos = new PVector(_x, enemyPos.y + blockSize*0.5);
        blocks.get(30 + half*i).blockPos = new PVector(_x, enemyPos.y + blockSize*3.5);
      }
      break;

      case(2):
      _x = enemyPos.x;
      int _half = half-2;
      for(int j = 0; j < 4; j++) {
        blocks.get(j).blockPos = new PVector(_x, enemyPos.y - blockSize*1.5 + blockSize*j);
      }
      for(int i = 0; i < 2; i++) {
        flip = 1 - i*2;
        _x = enemyPos.x + blockSize*flip;
        blocks.get(4 + _half*i).blockPos = new PVector(_x + (blockSize*3)*flip, enemyPos.y + blockSize*1.5);
        for(int j = 5; j < 9; j++) {
          blocks.get(j + _half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*1.5 + blockSize*(j-5));
        }
        _x = enemyPos.x + (blockSize*2)*flip;
        blocks.get(9 + _half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*2.5);
        blocks.get(10 + _half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*1.5);
        blocks.get(11 + _half*i).blockPos = new PVector(_x, enemyPos.y + blockSize/2);
        blocks.get(12 + _half*i).blockPos = new PVector(_x, enemyPos.y + blockSize*1.5);
        blocks.get(13 + _half*i).blockPos = new PVector(_x + (blockSize*2)*flip, enemyPos.y + blockSize*3.5);
        _x = enemyPos.x + (blockSize*3)*flip;
        blocks.get(14 + _half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*3.5);
        for(int j = 15; j < 20; j++) {
          blocks.get(j + _half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*1.5 + blockSize*(j-15));
        }
        _x = enemyPos.x + (blockSize*4)*flip;
        blocks.get(20 + _half*i).blockPos = new PVector(_x, enemyPos.y - blockSize/2);
        blocks.get(21 + _half*i).blockPos = new PVector(_x, enemyPos.y + blockSize/2);
        _x = enemyPos.x + (blockSize*5)*flip;
        blocks.get(22 + _half*i).blockPos = new PVector(_x, enemyPos.y + blockSize/2);
        blocks.get(23 + _half*i).blockPos = new PVector(_x, enemyPos.y - blockSize/2);
        blocks.get(24 + _half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*1.5);
        blocks.get(25 + _half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*2.5);
      }
      break;

      case(3):
      for(int i = 0; i < 2; i++) {
        flip = 1 - i*2;
        _x = enemyPos.x + (blockSize/2)*flip;
        for (int j = 0; j < 5; j++) {
          blocks.get(j + half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*3.5 + blockSize*j);
        }
        blocks.get(5 + half*i).blockPos = new PVector(_x, enemyPos.y + blockSize*2.5);
        _x = enemyPos.x + (blockSize*1.5)*flip;
        blocks.get(6 + half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*2.5);
        blocks.get(7 + half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*1.5);
        blocks.get(8 + half*i).blockPos = new PVector(_x, enemyPos.y + blockSize/2);
        blocks.get(9 + half*i).blockPos = new PVector(_x, enemyPos.y + blockSize*1.5);
        blocks.get(10 + half*i).blockPos = new PVector(_x, enemyPos.y + blockSize*3.5);
        _x = enemyPos.x + (blockSize*2.5)*flip;
        blocks.get(11 + half*i).blockPos = new PVector(_x, enemyPos.y - blockSize*1.5);
        blocks.get(12 + half*i).blockPos = new PVector(_x, enemyPos.y - blockSize/2);
        blocks.get(13 + half*i).blockPos = new PVector(_x, enemyPos.y + blockSize/2);
        blocks.get(14 + half*i).blockPos = new PVector(_x, enemyPos.y + blockSize*2.5);
        _x = enemyPos.x + (blockSize*3.5)*flip;
        blocks.get(15 + half*i).blockPos = new PVector(_x, enemyPos.y - blockSize/2);
        blocks.get(16 + half*i).blockPos = new PVector(_x, enemyPos.y + blockSize/2);
        blocks.get(17 + half*i).blockPos = new PVector(_x, enemyPos.y + blockSize*3.5);
      }
      break;

      case(10):
      for(int j = 0; j < 2; j++) {
        flip = 1 - j*2;
        for(int i = 0; i < 6; i++) {
          blocks.get(i+ half*j).blockPos = new PVector(enemyPos.x + (blockSize/2)*flip, enemyPos.y - blockSize*3 + blockSize*i);
        }
        for(int i = 6; i < 9; i++) {
          blocks.get(i+ half*j).blockPos = new PVector(enemyPos.x + (blockSize*1.5)*flip, enemyPos.y - blockSize*3 + blockSize*(i-6));
        }
        blocks.get(9+ half*j).blockPos = new PVector (enemyPos.x + (blockSize*1.5)*flip, enemyPos.y + blockSize);

        for(int i = 10; i < 15; i++) {
          blocks.get(i+ half*j).blockPos = new PVector (enemyPos.x + (blockSize*2.5)*flip, enemyPos.y - blockSize *3 + blockSize*(i-10));
        }
        for(int i = 15; i < 20; i++) {
          blocks.get(i + half*j).blockPos = new PVector (enemyPos.x + (blockSize*3.5)*flip, enemyPos.y - blockSize *2 + blockSize*(i-15));
        }
        for(int i = 20; i < 22; i++) {
          blocks.get(i + half*j).blockPos = new PVector (enemyPos.x + (blockSize*4.5)*flip, enemyPos.y - blockSize*2 + blockSize*(i-20));
        }
        for(int i = 22; i < 25; i++) {
          blocks.get(i + half*j).blockPos = new PVector (enemyPos.x + (blockSize*4.5)* flip, enemyPos.y + blockSize + blockSize*(i-22));
        }
        for(int i = 25; i < 29; i++) {
          blocks.get(i + half*j).blockPos = new PVector (enemyPos.x + (blockSize*5.5)*flip, enemyPos.y - blockSize + blockSize * (i-25));
        }
        blocks.get(29 + half * j).blockPos = new PVector (enemyPos.x + (blockSize*6.5)*flip, enemyPos.y );
        blocks.get(30 + half * j).blockPos = new PVector (enemyPos.x + (blockSize*6.5)*flip, enemyPos.y + blockSize);
        blocks.get(31 + half * j).blockPos = new PVector (enemyPos.x + (blockSize*7.5)*flip, enemyPos.y + blockSize);
      }
      break;
    }
  }
}

