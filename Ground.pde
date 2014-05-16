//
//
//

class Ground {
  ArrayList<Block> blocks = new ArrayList<Block>();
  int blockSize;

  float groundHeight = height/30;
  float groundY;
  int half;

  Ground() {
    groundY = height - groundHeight;
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
   
   for (int _x = 0; _x < 10; _x++){
      for (int _y = 0; _y < 10; _y++) {
        Block block = new Block(new PVector(100 + blockSize*_y + blockSize*_x, height-80 + blockSize *_y ), blockSize);
        blocks.add(block);
        block.bFill = color(0, 255, 0);
     }
     }
     for (int _x = 0; _x < 10; _x++){
       for (int _y = 0; _y < 5; _y++) {
        Block block = new Block(new PVector(95 + blockSize + blockSize*_x, height-90 + blockSize *_y ), blockSize);
        blocks.add(block);
        block.bFill = color(0, 255, 0);
     }
     }
          for (int _x = 0; _x < 10; _x++){   
       for (int _y = 0; _y < 5; _y++) {
        Block block = new Block(new PVector(105 + blockSize + blockSize*_x, height-70 + blockSize *_y ), blockSize);
        blocks.add(block);
        block.bFill = color(0, 255, 0);
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

