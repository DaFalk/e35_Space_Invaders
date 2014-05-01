class Block {
  float x, y;
  PVector blockPos;
  int blockSize = 2;
  int lastMove, speed;
  boolean release = false;
  
  Block(PVector _blockPos) {
    this.blockPos = _blockPos;
  }
  
  void display() {
    rectMode(CENTER);
    noStroke();
    fill(255);
    if(release) { releaseBlocks(); }
    rect(blockPos.x, blockPos.y, blockSize, blockSize);
  }
  
  void releaseBlocks() {
    blockPos.y += 96*(millis()-lastMove)*0.001;
    lastMove = millis();
  }
}
