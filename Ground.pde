/*
This class creates the 4 covers and the ground out of blocks and manages the shot and enemy impacts on these.
 */

class Ground {
  ArrayList<Block> groundBlocks = new ArrayList<Block>();
  ArrayList<Block> coverBlocks = new ArrayList<Block>();

  int blockSize;
  float groundHeight = height/30;
  float groundY;
  float coverY = height - dynamicValue(115);
  float coverWidth, coverHeight;

  color groundColor = color(0, 255, 0);

  Ground() {
    groundY = height - groundHeight;
    blockSize = spawner.blockSize;
    coverWidth = 40*blockSize;
    coverHeight = coverWidth/2;
  }

  void spawnGround() {
    //Setup ground blocks in a rectangular grid.
    for (int row = 0; row < groundHeight/blockSize; row++) {
      for (int col = 0; col < width/blockSize; col++) {
        Block block = new Block(new PVector(col + blockSize/2 + (blockSize/2)*col, groundY + blockSize/2 + blockSize*row), blockSize);
        groundBlocks.add(block);
        block.bFill = groundColor;  //Match ground color.
      }
    }
  }

  void spawnCover() {
    //Create 4 covers.
    for (int i = 0; i < 4; i++) {
      float indent = width/5 + blockSize/2;  //Amount to indent covers.
      indent += indent*i;  //Increase amount per iteration.
      for (int _x = 0; _x < 2; _x++) {
        int flip = 1 - _x*2;  //Only half the blocks are postioned manually the other half is mirrored.
        //Create the top.
        for (int col = 0; col < 9; col++) {
          for (int row = 0; row < 6; row++) {
            Block block = new Block(new PVector(indent + (blockSize*col)*flip, coverY + (blockSize*row)), blockSize);
            coverBlocks.add(block);
            block.bFill = groundColor;
          }
        }

        //Create the slopes.
        for (int col = 0; col < 10; col++) {
          for (int row = 0; row < 8; row++) {
            Block block = new Block(new PVector(indent + (blockSize*row)*flip + (blockSize*col)*flip, coverY + blockSize + blockSize*row ), blockSize);
            coverBlocks.add(block);
            block.bFill = groundColor;
          }
        }

        //create the bottom.
        for (int col = 0; col < 10; col++) {   
          for (int row = 0; row < 12; row++) {
            Block block = new Block(new PVector(indent + (blockSize*8 + blockSize*col)*flip, coverY + blockSize*9 + blockSize*row), blockSize);
            coverBlocks.add(block);
            block.bFill = groundColor;
          }
        }
      }
    }
  }

  void display() {
    for (int i = groundBlocks.size()-1; i > -1; i--) {
      groundBlocks.get(i).display();
    }
    for (int i = coverBlocks.size()-1; i > -1; i--) {
      coverBlocks.get(i).display();
    }
  }

  //Receives the block array that was hit, the impact position, the range of "explosion" and percentage chance that blocks are affected.
  void damageGround(ArrayList<Block> _blocks, PVector _shotPos, float _range, int _pct) {
    for (int i = _blocks.size()-1; i > -1; i--) {
      if (_blocks.get(i).blockPos.dist(_shotPos) < _range) {
        if (random(0, 100) > 100 - _pct) {
          _blocks.get(i).deathPos = new PVector(_shotPos.x, _shotPos.y + 10);
          _blocks.get(i).lastMove = millis();
          _blocks.get(i).home = _blocks;  //Set block home so block can remove it self once out of bounds.
        }
      }
    }
  }

  void reset() {
    groundBlocks.clear();
    coverBlocks.clear();
  }
}

