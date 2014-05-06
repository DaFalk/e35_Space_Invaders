//
//
// Accesse classes: spawner, menUI, audioHandler, enemyHandler, players[], enemies[]

class Enemy {
  ArrayList<Block> blocks;
  float x, y;
  int half;  //Half the size() of blocks arraylist.
  int blockSize, eSize, eHeight;
  int type, lifes, points;
  int lastAnim, nextAnim;
  int moveSwitch = 1;
  PVector lowestPoint = new PVector(0, 0);
  boolean isDead;
  color eFill;

  Enemy(int _type, float _x, float _y, int _blockSize) {
    this.isDead = false;
    this.type = _type;
    this.lifes = 6;
    this.x = _x;
    this.y = _y;
    this.points = type*10;
    this.eFill = color(255);
    this.blocks = new ArrayList<Block>();
    this.blockSize = _blockSize;
    this.eSize = 6*blockSize;
    this.eHeight = 4*blockSize;
    nextAnim = enemyHandler.nextMove*2;
    this.half = ceil(setArrayLength()/2);
    for (int i = 0; i < setArrayLength(); i ++) {
      blocks.add(new Block(new PVector(x, y), blockSize));
      blocks.get(i).bFill = eFill;
      blocks.get(i).owner = this;
    }
    setBlockPositions();
  }
  
  //Draw this enemy type using blocks and display the blocks
  void update() {
    for (int i = blocks.size()-1; i > -1; i--) {
      blocks.get(i).display();
      if(isDead) {
        if(blocks.get(i).blockPos.y > lowestPoint.y) {
          lowestPoint = blocks.get(i).blockPos;
        }
      }
    }
    if(isDead) {
      if(checkBlockCollision()) { enemies.remove(this); }
    }
    animateEnemy();
  }
  
  void moveEnemy(float _amountX, float _amountY) {
    x += _amountX;
    y += _amountY;
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
    if(millis() - lastAnim >= nextAnim) {
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
      lastAnim = millis();
    }
  }
  
  void damageEnemy(Shot _shot) {
   //Deal damage to enemy.
    if(lifes > 0) {
       lifes -= _shot.damage;
       eFill = color(255, 51*(lifes-1), 51*(lifes-1));
       setBlocksFill();
    }
   //Kill enemy, if it is the last then respawn all enemies.
    if(lifes <= 0 && !isDead) {
      isDead = true;
      audioHandler.playSFX(2);
      spawner.spawnPowerUp(x, y, (float)eSize);
      enemyHandler.deadEnemies.add(this);
      for(int i = blocks.size()-1; i > -1; i--) {
        blocks.get(i).deathPos = new PVector(x, y);
        blocks.get(i).lastMove = millis();
      }
     //remove enemy, add points to player score and show points UI.
      if(enemies.size() > 1) {
        players.get(_shot.owner).score += points;
        menUI.pointsTexts.add(new PointsText(x, y, points));
      }
      else {  //Add points to player score, show points UI and respawn enemies.
        players.get(_shot.owner).score += points;
        menUI.pointsTexts.add(new PointsText(x, y, points));
        audioHandler.playSFX(6);
        enemyHandler.respawnEnemies = true;
      }
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
            if(_player.hasShield) { _player.hasShield = false; }
            else { _player.adjustLifes(); }
            return true;
          }
        }
      }
    }
    return false;
  }
  
  void setBlockPositions() {
    int flip;
    float _x;
    switch(type) {
      case(1):
        for (int i = 0; i < 2; i++) {
          flip = 1 - i*2;
          _x = x + (blockSize/2)*flip;
          for (int j = 0; j < 5; j++) {
            blocks.get(j + half*i).blockPos = new PVector(_x, y - blockSize*3.5 + blockSize*j);
          }
          blocks.get(5 + half*i).blockPos = new PVector(_x, y + blockSize*2.5);
          _x = x + (blockSize*1.5)*flip;
          blocks.get(6 + half*i).blockPos = new PVector(_x, y - blockSize*3.5);
          blocks.get(7 + half*i).blockPos = new PVector(_x, y - blockSize*2.5);
          blocks.get(8 + half*i).blockPos = new PVector(_x, y - blockSize*1.5);
          blocks.get(9 + half*i).blockPos = new PVector(_x, y + blockSize/2);
          blocks.get(10 + half*i).blockPos = new PVector(_x, y + blockSize*1.5);
          _x = x + (blockSize*2.5)*flip;
          blocks.get(11 + half*i).blockPos = new PVector(_x, y - blockSize*2.5);
          blocks.get(12 + half*i).blockPos = new PVector(_x, y - blockSize*1.5);
          blocks.get(13 + half*i).blockPos = new PVector(_x, y + blockSize*0.5);
          blocks.get(14 + half*i).blockPos = new PVector(_x, y + blockSize*1.5);
          _x = x + (blockSize*3.5)*flip;
          blocks.get(15 + half*i).blockPos = new PVector(_x - blockSize*flip, y + blockSize*2.5);
          for(int j = 16; j < 20; j++) {
            blocks.get(j + half*i).blockPos = new PVector(_x, y - blockSize*2.5 + blockSize*(j-16));
          }
          blocks.get(20 + half*i).blockPos = new PVector(_x, y + blockSize*2.5);
          blocks.get(21 + half*i).blockPos = new PVector(_x - (blockSize*3)*flip, y + blockSize*2.5);
          _x = x + (blockSize*4.5)*flip;
          for(int j = 22; j < 26; j++) {
            blocks.get(j + half*i).blockPos = new PVector(_x, y - blockSize*2.5 + blockSize*(j-22));
          }
          _x = x + (blockSize*5.5)*flip;
          blocks.get(26 + half*i).blockPos = new PVector(_x - (blockSize*1)*flip, y + blockSize*3.5);
          blocks.get(27 + half*i).blockPos = new PVector(_x, y - blockSize*1.5);
          blocks.get(28 + half*i).blockPos = new PVector(_x, y - blockSize*0.5);
          blocks.get(29 + half*i).blockPos = new PVector(_x, y + blockSize*0.5);
          blocks.get(30 + half*i).blockPos = new PVector(_x, y + blockSize*3.5);
        }
      break;
      
      case(2):
        _x = x;
        int _half = half-2;
        for(int j = 0; j < 4; j++) {
          blocks.get(j).blockPos = new PVector(_x, y - blockSize*1.5 + blockSize*j);
        }
        for (int i = 0; i < 2; i++) {
          flip = 1 - i*2;
          _x = x + blockSize*flip;
          blocks.get(4 + _half*i).blockPos = new PVector(_x + (blockSize*3)*flip, y + blockSize*1.5);
          for(int j = 5; j < 9; j++) {
            blocks.get(j + _half*i).blockPos = new PVector(_x, y - blockSize*1.5 + blockSize*(j-5));
          }
          _x = x + (blockSize*2)*flip;
          blocks.get(9 + _half*i).blockPos = new PVector(_x, y - blockSize*2.5);
          blocks.get(10 + _half*i).blockPos = new PVector(_x, y - blockSize*1.5);
          blocks.get(11 + _half*i).blockPos = new PVector(_x, y + blockSize/2);
          blocks.get(12 + _half*i).blockPos = new PVector(_x, y + blockSize*1.5);
          blocks.get(13 + _half*i).blockPos = new PVector(_x + (blockSize*2)*flip, y + blockSize*3.5);
          _x = x + (blockSize*3)*flip;
          blocks.get(14 + _half*i).blockPos = new PVector(_x, y - blockSize*3.5);
          for(int j = 15; j < 20; j++) {
            blocks.get(j + _half*i).blockPos = new PVector(_x, y - blockSize*1.5 + blockSize*(j-15));
          }
          _x = x + (blockSize*4)*flip;
          blocks.get(20 + _half*i).blockPos = new PVector(_x, y - blockSize/2);
          blocks.get(21 + _half*i).blockPos = new PVector(_x, y + blockSize/2);
          _x = x + (blockSize*5)*flip;
          blocks.get(22 + _half*i).blockPos = new PVector(_x, y + blockSize/2);
          blocks.get(23 + _half*i).blockPos = new PVector(_x, y - blockSize/2);
          blocks.get(24 + _half*i).blockPos = new PVector(_x, y - blockSize*1.5);
          blocks.get(25 + _half*i).blockPos = new PVector(_x, y - blockSize*2.5);
        }
      break;
      
      case(3):
        for (int i = 0; i < 2; i++) {
          flip = 1 - i*2;
          _x = x + (blockSize/2)*flip;
          for (int j = 0; j < 5; j++) {
            blocks.get(j + half*i).blockPos = new PVector(_x, y - blockSize*3.5 + blockSize*j);
          }
          blocks.get(5 + half*i).blockPos = new PVector(_x, y + blockSize*2.5);
          _x = x + (blockSize*1.5)*flip;
          blocks.get(6 + half*i).blockPos = new PVector(_x, y - blockSize*2.5);
          blocks.get(7 + half*i).blockPos = new PVector(_x, y - blockSize*1.5);
          blocks.get(8 + half*i).blockPos = new PVector(_x, y + blockSize/2);
          blocks.get(9 + half*i).blockPos = new PVector(_x, y + blockSize*1.5);
          blocks.get(10 + half*i).blockPos = new PVector(_x, y + blockSize*3.5);
          _x = x + (blockSize*2.5)*flip;
          blocks.get(11 + half*i).blockPos = new PVector(_x, y - blockSize*1.5);
          blocks.get(12 + half*i).blockPos = new PVector(_x, y - blockSize/2);
          blocks.get(13 + half*i).blockPos = new PVector(_x, y + blockSize/2);
          blocks.get(14 + half*i).blockPos = new PVector(_x, y + blockSize*2.5);
          _x = x + (blockSize*3.5)*flip;
          blocks.get(15 + half*i).blockPos = new PVector(_x, y - blockSize/2);
          blocks.get(16 + half*i).blockPos = new PVector(_x, y + blockSize/2);
          blocks.get(17 + half*i).blockPos = new PVector(_x, y + blockSize*3.5);
        }
      break;
    }
  }
}
