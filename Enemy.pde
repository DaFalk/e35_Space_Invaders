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
  boolean moveSwitch = false;
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
    colorBlocks();
  }
  
  //Draw this enemy type using blocks and display the blocks
  void update() {
    if(!isDead) { displayType(type); }
    for (int i = blocks.size()-1; i > -1; i--) {
      blocks.get(i).display();
    }
    animateEnemy();
  }
  
  void damageEnemy(int _player, int _dmg) {
   //Deal damage to enemy.
    if(lifes > 0) {
       lifes -= _dmg;
       eFill = color(255, 51*(lifes-1), 51*(lifes-1));
       colorBlocks();
    }
   //Kill enemy, if it is the last then respawn all enemies.
    if(lifes <= 0) {
      isDead = true;
      audioHandler.playSFX(2);
      spawner.spawnPowerUp(x, y, (float)eSize);
     //remove enemy, add points to player score and show points UI.
      if(enemies.size() > 1) {
        enemies.remove(this);
        for(int i = blocks.size()-1; i > -1; i--) {
          blocks.get(i).deathPos = new PVector(x, y);
          blocks.get(i).lastMove = millis();
        }
        players.get(_player).score += points;
        menUI.pointsTexts.add(new PointsText(x, y, points));
      }
      else {  //Add points to player score, show points UI and respawn enemies.
        players.get(_player).score += points;
        menUI.pointsTexts.add(new PointsText(enemies.get(0).x, enemies.get(0).y, enemies.get(0).points));
        audioHandler.playSFX(6);
        spawner.respawnEnemies = true;
      }
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
  
  void displayType(int _type) {
    if(_type == 1) {
      for (int i = 0; i < 2; i++) {
        int _flip = 1 - i*2;
        float _x = x + (blockSize/2)*_flip;
        for (int j = 0; j < 5; j++) {
          blocks.get(j + half*i).blockPos = new PVector(_x, y - blockSize*3.5 + blockSize*j);
        }
        blocks.get(5 + half*i).blockPos = new PVector(_x, y + blockSize*2.5);
        _x = x + (blockSize*1.5)*_flip;
        blocks.get(6 + half*i).blockPos = new PVector(_x, y - blockSize*3.5);
        blocks.get(7 + half*i).blockPos = new PVector(_x, y - blockSize*2.5);
        blocks.get(8 + half*i).blockPos = new PVector(_x, y - blockSize*1.5);
        blocks.get(9 + half*i).blockPos = new PVector(_x, y + blockSize/2);
        blocks.get(10 + half*i).blockPos = new PVector(_x, y + blockSize*1.5);
        _x = x + (blockSize*2.5)*_flip;
        blocks.get(11 + half*i).blockPos = new PVector(_x, y - blockSize*2.5);
        blocks.get(12 + half*i).blockPos = new PVector(_x, y - blockSize*1.5);
        blocks.get(13 + half*i).blockPos = new PVector(_x, y + blockSize*0.5);
        blocks.get(14 + half*i).blockPos = new PVector(_x, y + blockSize*1.5);
        _x = x + (blockSize*3.5)*_flip;
        for(int j = 16; j < 20; j++) {
          blocks.get(j + half*i).blockPos = new PVector(_x, y - blockSize*2.5 + blockSize*(j-16));
        }
        blocks.get(20 + half*i).blockPos = new PVector(_x, y + blockSize*2.5);
        _x = x + (blockSize*4.5)*_flip;
        for(int j = 22; j < 26; j++) {
          blocks.get(j + half*i).blockPos = new PVector(_x, y - blockSize*2.5 + blockSize*(j-22));
        }
        _x = x + (blockSize*5.5)*_flip;
        blocks.get(27 + half*i).blockPos = new PVector(_x, y - blockSize*1.5);
        blocks.get(28 + half*i).blockPos = new PVector(_x, y - blockSize*0.5);
        blocks.get(29 + half*i).blockPos = new PVector(_x, y + blockSize*0.5);
        
        if(!moveSwitch) {
          blocks.get(15 + half*i).blockPos = new PVector(_x - (blockSize*3)*_flip, y + blockSize*2.5);
          blocks.get(21 + half*i).blockPos = new PVector(_x - (blockSize*2)*_flip, y);
          blocks.get(26 + half*i).blockPos = new PVector(_x - (blockSize*1)*_flip, y + blockSize*3.5);
          blocks.get(30 + half*i).blockPos = new PVector(_x, y + blockSize*3.5);
        }
        else {
          blocks.get(15 + half*i).blockPos = new PVector(_x - (blockSize*3)*_flip, y + blockSize*3.5);
          blocks.get(21 + half*i).blockPos = new PVector(_x - (blockSize*2)*_flip, y + blockSize*1.5);
          blocks.get(26 + half*i).blockPos = new PVector(_x - (blockSize*1)*_flip, y + blockSize*2.5);
          blocks.get(30 + half*i).blockPos = new PVector(_x - (blockSize*2)*_flip, y + blockSize*3.5);
        }
      }
    }
    else if(type == 2) {
      float _x = x;
      int _half = half-2;
      for(int j = 0; j < 4; j++) {
        blocks.get(j).blockPos = new PVector(_x, y - blockSize*1.5 + blockSize*j);
      }
      for (int i = 0; i < 2; i++) {
        int _flip = 1 - i*2;
        _x = x + blockSize*_flip;
        for(int j = 5; j < 9; j++) {
          blocks.get(j + _half*i).blockPos = new PVector(_x, y - blockSize*1.5 + blockSize*(j-5));
        }
        _x = x + (blockSize*2)*_flip;
        blocks.get(9 + _half*i).blockPos = new PVector(_x, y - blockSize*2.5);
        blocks.get(10 + _half*i).blockPos = new PVector(_x, y - blockSize*1.5);
        blocks.get(11 + _half*i).blockPos = new PVector(_x, y + blockSize/2);
        blocks.get(12 + _half*i).blockPos = new PVector(_x, y + blockSize*1.5);
        _x = x + (blockSize*3)*_flip;
        blocks.get(14 + _half*i).blockPos = new PVector(_x, y - blockSize*3.5);
        for(int j = 15; j < 20; j++) {
          blocks.get(j + _half*i).blockPos = new PVector(_x, y - blockSize*1.5 + blockSize*(j-15));
        }
        _x = x + (blockSize*4)*_flip;
        blocks.get(20 + _half*i).blockPos = new PVector(_x, y - blockSize/2);
        blocks.get(21 + _half*i).blockPos = new PVector(_x, y + blockSize/2);
        _x = x + (blockSize*5)*_flip;
        blocks.get(22 + _half*i).blockPos = new PVector(_x, y + blockSize/2);
        
        if(!moveSwitch) {
          blocks.get(4 + _half*i).blockPos = new PVector(_x - blockSize*_flip, y + blockSize*1.5);
          blocks.get(13 + _half*i).blockPos = new PVector(_x - blockSize*_flip, y + blockSize*3.5);
          blocks.get(23 + _half*i).blockPos = new PVector(_x, y - blockSize/2);
          blocks.get(24 + _half*i).blockPos = new PVector(_x, y - blockSize*1.5);
          blocks.get(25 + _half*i).blockPos = new PVector(_x, y - blockSize*2.5);
        }
        else {
          blocks.get(4 + _half*i).blockPos = new PVector(_x - (blockSize*4)*_flip, y + blockSize*3.5);
          blocks.get(13 + _half*i).blockPos = new PVector(_x - (blockSize*3)*_flip, y + blockSize*3.5);
          blocks.get(23 + _half*i).blockPos = new PVector(_x, y + blockSize*2.5);
          blocks.get(24 + _half*i).blockPos = new PVector(_x, y + blockSize*1.5);
          blocks.get(25 + _half*i).blockPos = new PVector(_x, y + blockSize/2);
        }
      }
    }
    else if(type == 3) {
      for (int i = 0; i < 2; i++) {
        int _flip = 1 - i*2;
        float _x = x + (blockSize/2)*_flip;
        for (int j = 0; j < 5; j++) {
          blocks.get(j + half*i).blockPos = new PVector(_x, y - blockSize*3.5 + blockSize*j);
        }
        _x = x + (blockSize*1.5)*_flip;
        blocks.get(6 + half*i).blockPos = new PVector(_x, y - blockSize*2.5);
        blocks.get(7 + half*i).blockPos = new PVector(_x, y - blockSize*1.5);
        blocks.get(8 + half*i).blockPos = new PVector(_x, y + blockSize/2);
        _x = x + (blockSize*2.5)*_flip;
        blocks.get(11 + half*i).blockPos = new PVector(_x, y - blockSize*1.5);
        blocks.get(12 + half*i).blockPos = new PVector(_x, y - blockSize/2);
        blocks.get(13 + half*i).blockPos = new PVector(_x, y + blockSize/2);
        _x = x + (blockSize*3.5)*_flip;
        blocks.get(15 + half*i).blockPos = new PVector(_x, y - blockSize/2);
        blocks.get(16 + half*i).blockPos = new PVector(_x, y + blockSize/2);
        
        if(!moveSwitch) {
          blocks.get(5 + half*i).blockPos = new PVector(_x - (blockSize*3)*_flip, y + blockSize*2.5);
          blocks.get(9 + half*i).blockPos = new PVector(_x - (blockSize*2)*_flip, y + blockSize*1.5);
          blocks.get(10 + half*i).blockPos = new PVector(_x - (blockSize*2)*_flip, y + blockSize*3.5);
          blocks.get(14 + half*i).blockPos = new PVector(_x - (blockSize*1)*_flip, y + blockSize*2.5);
          blocks.get(17 + half*i).blockPos = new PVector(_x, y + blockSize*3.5);
        }
        else {
          blocks.get(5 + half*i).blockPos = new PVector(_x - (blockSize*3)*_flip, y + blockSize*1.5);
          blocks.get(9 + half*i).blockPos = new PVector(_x - (blockSize*1)*_flip, y + blockSize*1.5);
          blocks.get(10 + half*i).blockPos = new PVector(_x - (blockSize*1)*_flip, y + blockSize*3.5);
          blocks.get(14 + half*i).blockPos = new PVector(_x - (blockSize*1)*_flip, y - blockSize/2);
          blocks.get(17 + half*i).blockPos = new PVector(_x, y + blockSize*2.5);
        }
      }
    }
  }
  
  void colorBlocks() {
    for (int i = 0; i < setArrayLength(); i ++) {
      blocks.add(new Block(new PVector(x, y), blockSize));
      blocks.get(i).bFill = eFill;
    }
  }
  
  void animateEnemy() {
    if(millis() - lastAnim >= nextAnim) {
      moveSwitch = !moveSwitch;
      lastAnim = millis();
    }
  }
}

