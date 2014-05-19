//
//
//

class Ground {
  ArrayList<Block> groundBlocks = new ArrayList<Block>();
  ArrayList<Block> coverBlocks = new ArrayList<Block>();
  int blockSize;
  float groundHeight = height/30;
  float groundY;
  float coverY = height - dynamicValue(115);
  float coverWidth;
  float coverHeight;
  color groundColor = color(0, 255, 0);
  int half;

  Ground() {
    groundY = height - groundHeight;
    blockSize = spawner.blockSize;
    coverWidth = 40*blockSize;
    coverHeight = coverWidth/2;
  }

  void spawnGround() {
    //Setup ground blocks.
    for(int _y = 0; _y < groundHeight/blockSize; _y++) {
      for(int _x = 0; _x < width/blockSize; _x++) {
        Block block = new Block(new PVector(_x + blockSize/2 + (blockSize/2)*_x, groundY + blockSize/2 + blockSize*_y), blockSize);
        groundBlocks.add(block);
        block.bFill = groundColor;
      }
    }
  }

  void spawnCover() {
    for(int seed = 0; seed < 4; seed++) {
      float indent = width/5 + blockSize/2;
      indent += indent*seed;
      for(int i = 0; i < 2; i++) {
        int flip = 1 - i*2;
        //Draw the top.
        for(int _x = 0; _x < 9; _x++) {
          for(int _y = 0; _y < 6; _y++) {
            Block block = new Block(new PVector(indent + (blockSize*_x)*flip, coverY + (blockSize*_y)), blockSize);
            coverBlocks.add(block);
            block.bFill = groundColor;
          }
        }
        
        //Draw the slopes.
        for(int _x = 0; _x < 10; _x++) {
          for(int _y = 0; _y < 8; _y++) {
            Block block = new Block(new PVector(indent + (blockSize*_y)*flip + (blockSize*_x)*flip, coverY + blockSize + blockSize*_y ), blockSize);
            coverBlocks.add(block);
            block.bFill = groundColor;
          }
        }
        
        //Draw the "legs".
        for(int _x = 0; _x < 10; _x++) {   
          for(int _y = 0; _y < 12; _y++) {
            Block block = new Block(new PVector(indent + (blockSize*8 + blockSize*_x)*flip, coverY + blockSize*9 + blockSize*_y ), blockSize);
            coverBlocks.add(block);
            block.bFill = groundColor;
          }
        }
      }
    }
  }

  void display() {
    for(int i = groundBlocks.size()-1; i > -1; i--) {
      groundBlocks.get(i).display();
    }
    for(int i = coverBlocks.size()-1; i > -1; i--) {
      coverBlocks.get(i).display();
    }
  }

  void damageGround(ArrayList<Block> _blocks, PVector _shotPos, float _range, int _pct) {
    for(int i = _blocks.size()-1; i > -1; i--) {
      if(_blocks.get(i).blockPos.dist(_shotPos) < _range) {
        if(random(0, 100) > 100 - _pct) {
          _blocks.get(i).deathPos = new PVector(_shotPos.x, _shotPos.y + 10);
          _blocks.get(i).lastMove = millis();
          _blocks.get(i).home = _blocks;
        }
      }
    }
  }

  void reset() {
    groundBlocks.clear();
    coverBlocks.clear();
  }
}

