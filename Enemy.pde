//
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
  boolean isDead = false;
  boolean doAnimation = true;
  PVector lowestPoint = new PVector(0, 0);
  color eFill;
  int fadeStart = 0;
  float fadeAmount = 0;

  Enemy(int _type, PVector _pos, int _blockSize) {
    type = _type;
    points = type*5;
    lifes = 6;
    enemyPos = _pos;
    eFill = color(255);
    blocks = new ArrayList<Block>();
    blockSize = _blockSize;
    eSize = 6*blockSize;
    eHeight = 4*blockSize;
    half = ceil(setArrayLength()/2);
    for (int i = 0; i < setArrayLength(); i ++) {
      blocks.add(new Block(enemyPos, blockSize));
      blocks.get(i).bFill = eFill;
      blocks.get(i).owner = this;
    }
    setBlockPositions();
  }
  
  //Draw enemy type using blocks and display the blocks
  void update() {
    for (int i = blocks.size()-1; i > -1; i--) {
      blocks.get(i).display();
      if(isDead) {
        if(blocks.get(i).blockPos.y > lowestPoint.y) {
          lowestPoint = blocks.get(i).blockPos;
        }
      }
    }
    if(fadeStart > 0) {
      fade();
    }
    if(checkBlockCollision() && isDead) { deadEnemies.remove(this); }
  }
  
  void moveEnemy(float _amountX, float _amountY) {
    enemyPos.x += _amountX;
    enemyPos.y += _amountY;
    for(int i = blocks.size()-1; i > -1; i--) {
      blocks.get(i).blockPos.x += _amountX;
      blocks.get(i).blockPos.y += _amountY;
    } 
  }

  int setArrayLength() {
    if (type == 1) { return 62; }
    else if (type == 2) { return 48; }
    else if (type == 3) { return 36; }
//    else if (type == 4) { return 64; }  //Boss
    else { return 0; }
  }
  
  void setBlocksFill() {
    for (int i = 0; i < setArrayLength(); i ++) {
      blocks.get(i).bFill = eFill;
    }
  }
  
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
    moveSwitch *= -1;
  }
  
  void damageEnemy(Shot _shot) {
    //Deal shot damage to enemy and adjust enemy color according to lifes left.
    if(lifes > 0) {
      int _shotDamage = _shot.damage; 
      if(this != _shot.target && _shot.type == 3) { _shotDamage = _shot.damage/2; }
      lifes -= _shotDamage;
      eFill = color(255, 51*(lifes-1), 51*(lifes-1), 255 - fadeAmount);
      setBlocksFill();
    }
    
    //Kill enemy if lifes goes below zero.
    if(lifes <= 0 && !isDead) {
      isDead = true;
      audioHandler.playSFX(2);
      
      //Adjust player score and initialize floating points.
      players.get(_shot.owner).score += points;
      FloatingText floatingPoints = new FloatingText(enemyPos);
      floatingPoints.score = points;
      menUI.floatingTexts.add(floatingPoints);
      
      //Check if enemy should spawn a powerup.
      spawner.spawnPowerUp(enemyPos, (float)eSize);
      
      //Set blocks deathPos to initialize their movement.
      int _blockDir = 1;
      if(random(0, 100) > 75) { _blockDir = -1; }
      else {
        doAnimation = false;
        fadeStart = millis();
      }
      for(int i = blocks.size()-1; i > -1; i--) {
        blocks.get(i).blockDir = _blockDir;
        blocks.get(i).deathPos = new PVector(enemyPos.x, enemyPos.y);
        blocks.get(i).lastMove = millis();
      }
      
      //Respawn enemies if this enemy was the last.
      if(enemies.size() == 1) {
        audioHandler.playSFX(6);
        enemyHandler.respawnEnemies = true;
      }
      
      //Add to new arraylist and remove from the old (to avoid interfering with shot targetting  and animation).
      deadEnemies.add(this);
      enemies.remove(this);
    }
  }
  
  boolean checkBlockCollision() {
    //Check if enemy shot collides with a player
    for(int i = players.size() - 1; i > -1; i--) {
      Player _player = players.get(i);
      if(!_player.isDead) {
        if((lowestPoint.y > _player.y - _player.pHeight - _player.pHeight/3 && lowestPoint.y < _player.y + _player.pHeight)) {
          if((lowestPoint.x > _player.x && lowestPoint.x < _player.x + _player.pWidth)) {
            if(!_player.hasShield) { _player.adjustLifes(); }
            else { _player.hasShield = false; }
            return true;
          }
        }
      }
    }
    return false;
  }
  
  void fade() {
    fadeAmount += 1*(millis() - fadeStart)*0.001;
    if(fadeAmount > 255) { deadEnemies.remove(this); );}
    for(int i = blocks.size()-1; i > -1; i--) {
      blocks.get(i).currentAlpha -= fadeAmount;      
    }
  }
  
  void setBlockPositions() {
    int flip;
    float _x;
    switch(type) {
      case(1):
        for (int i = 0; i < 2; i++) {
          flip = 1 - i*2;
          _x = enemyPos.x + (blockSize/2)*flip;
          for (int j = 0; j < 5; j++) {
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
        for (int i = 0; i < 2; i++) {
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
        for (int i = 0; i < 2; i++) {
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
    }
  }
}
