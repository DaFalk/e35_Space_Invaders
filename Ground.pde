
class Ground {
  ArrayList<Block> blocks = new ArrayList<Block>();
  int blockSize;

  float groundHeight = height/30;
  float groundY;
  float coverY;
  float coverWidth;
  float coverHeight;
  int half;

  Ground() {
    groundY = height - groundHeight;
    coverY = height - dynamicValue(112);
    
    coverWidth =  20*blockSize;
    coverHeight = 36*blockSize;
    
    blockSize = spawner.blockSize;
  }

  void spawnGround() {
    //Setup ground blocks.
    for (int _y = 0; _y < groundHeight/blockSize; _y++) {
      for (int _x = 0; _x < width/blockSize; _x++) {
        Block block = new Block(new PVector(_x + blockSize/2 + (blockSize/2)*_x, height - groundHeight + blockSize/2 + blockSize*_y), blockSize);
        blocks.add(block);
        block.bFill = color(0, 255, 0);
      }
    }
  }

  void spawnCover() {
    for (int seed = 0; seed < 4; seed++) {
      
      float indent = width/5;
      indent += indent*seed;

      for (int i = 0; i < 2; i++) {

        int flip = 1 - i*2;

        for (int _x = 0; _x < 9; _x++) {
          for (int _y = 0; _y < 6; _y++) {
            Block block = new Block(new PVector(indent + (blockSize*_x) *flip, coverY + (blockSize *_y) ), blockSize);
            blocks.add(block);
            block.bFill = color(0, 255, 0);
          }
        }
        
        for (int _x = 0; _x < 10; _x++) {
          for (int _y = 0; _y < 8; _y++) {
            Block block = new Block(new PVector(indent + (blockSize*_y)*flip + (blockSize*_x)*flip, coverY + blockSize + blockSize *_y ), blockSize);
            blocks.add(block);
            block.bFill = color(0, 255, 0);
          }
        }

        for (int _x = 0; _x < 10; _x++) {   
          for (int _y = 0; _y < 12; _y++) {
            Block block = new Block(new PVector(indent + (blockSize*8 + blockSize*_x) *flip, coverY + (blockSize*9) + (blockSize *_y) ), blockSize);
            blocks.add(block);
            block.bFill = color(0, 255, 0);
          }
        }
      }
    }
  }

  void display() {
    for (int i = blocks.size()-1; i > -1; i--) {
      blocks.get(i).display();
    }
  }

  void damageGround(PVector _shotPos) {
    for (int i = blocks.size()-1; i > -1; i--) {
      if (blocks.get(i).blockPos.dist(_shotPos) < blockSize*3) {
        if (random(0, 100) > 50) {
          blocks.get(i).deathPos = new PVector(_shotPos.x, _shotPos.y + 10);
          blocks.get(i).lastMove = millis();
        }
      }
    }
  }

  void reset() {
    blocks.clear();
  }
}

