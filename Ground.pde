class Ground {
  ArrayList<Block> blocks = new ArrayList<Block>();
  int blockSize;
  
  float groundHeight = height/30;
  float groundY;
  
  Ground() {
    groundY = height - groundHeight;
    blockSize = spawner.blockSize;
  }
  
  void spawnGround() {
    //Setup ground blocks.
    for (int _y = 0; _y < groundHeight/blockSize; _y++) {
      for (int _x = 0; _x < width/blockSize; _x++) {
        Block block = new Block(new PVector(_x + blockSize/2 + (blockSize/2)*_x ,height - groundHeight + blockSize/2 + blockSize*_y), blockSize);
        blocks.add(block);
        block.bFill = color(0, 255, 0);
      }
    }
  }
  
  void display() {
    for(int i = blocks.size()-1; i > -1; i--) {
      blocks.get(i).display();
    }
  }
  
  void impactGround() {
    
  }
  
  void reset() {
    blocks.clear();
  }
}
