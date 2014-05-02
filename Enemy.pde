class Enemy {
  ArrayList<Block> blocks;
  int blockSize;
  int eSize, eHeight;
  float x, y;
  int type;
  int score;
  int lastShot;
  int shotCooldown;
  int weaponType = 0;
  int moveInterval = 100; 
  int lastMove;
  int half;
  boolean moveSwitch = false;

  Enemy(int _type, float _x, float _y, int _blockSize, int _shotCooldown) {
    this.type = _type;
    this.x = _x;
    this.y = _y;
    this.score = type*10;
    this.shotCooldown = _shotCooldown;
    this.blocks = new ArrayList<Block>();
    this.blockSize = _blockSize;
    this.eSize = 6*blockSize;
    this.eHeight = 4*blockSize;
    this.half = ceil(setArrayLength()/2);
    for (int i = 0; i < setArrayLength(); i ++) {
      blocks.add(new Block(new PVector(x, y), blockSize));
    }
  }
  
  void update() {
    displayType(type);
    for (int i = blocks.size()-1; i > -1; i--) {
      blocks.get(i).display();
    }
  }
  void displayType(int _type) {
    fill(255);
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

  void shoot() {
    if(millis() >= lastShot + shotCooldown) {
      int _i = floor(random(0, enemies.size()));
      Enemy _enemy = enemies.get(_i);
      Shot s = new Shot(_enemy.x, _enemy.y + _enemy.eSize, weaponType, 10);
      shots.add(s);
      lastShot = millis();
//      shotCooldown = ceil(random(3, 6))*1000;
      shotCooldown += millis();
    }
  }
  
  void killEnemy() {
    spawner.spawnPowerUp(x, y, (float)eSize);
    if(enemies.size() > 1) {
      enemies.remove(this);
      menUI.scoreTexts.add(new ScoreText(x, y, score));
    }
    else {
      menUI.scoreTexts.add(new ScoreText(enemies.get(0).x, enemies.get(0).y, enemies.get(0).score));
      spawner.respawnEnemies();
    }
  }

  int setArrayLength() {
    if (type == 1) { return 62; }
    else if (type == 2) { return 48; }
    else if (type == 3) { return 36; }
//    else if (type == 4) { return 64; }  //Boss
    else { return 0; }
  }
}

