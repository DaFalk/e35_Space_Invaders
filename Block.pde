class Block {
  PVector blockPos;
  int blockSize;
  int lastMove, speed;
  boolean release = false;
  
  Block(PVector _blockPos, int _blockSize) {
    this.blockPos = _blockPos;
    this.blockSize = _blockSize;
    if(!gameStarted) { this.blockPos = randomStarPos(-width); }
  }
  
  void display() {
    rectMode(CENTER);
    noStroke();
    if(release) { releaseBlock(); }
    rect(blockPos.x, blockPos.y, blockSize, blockSize);
  }
  
  void releaseBlock() {
    blockPos.y += 96*(millis()-lastMove)*0.001;
    lastMove = millis();
  }
  
  void moveBlock() {
    blockPos.x -= 500*(millis()-lastMove)*0.001;
    lastMove = millis();
    if(blockPos.x < -1) {
      blockPos = randomStarPos(0);
    }
    display();
  }
  
  PVector randomStarPos(float _offset) {
    return new PVector(random(width+_offset, width*2+_offset), random(height/4, height - height/4));
  }
}
