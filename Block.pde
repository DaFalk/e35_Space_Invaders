class Block {
  PVector blockPos;
  int blockSize;
  int lastMove, speed;
  boolean release = false;
  
  Block(PVector _blockPos, int _blockSize) {
    this.blockPos = _blockPos;
    this.blockSize = _blockSize;
  }
  
  void display() {
    rectMode(CENTER);
    noStroke();
    if(release) { releaseBlocks(); }
    rect(blockPos.x, blockPos.y, blockSize, blockSize);
  }
  
  void releaseBlocks() {
    blockPos.y += 96*(millis()-lastMove)*0.001;
    lastMove = millis();
  }
}
