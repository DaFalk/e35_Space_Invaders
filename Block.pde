class Block {
  PVector blockPos;
  int blockSize;
  int lastMove, speed;
  boolean release = false;
  
  Block(PVector _blockPos, int _blockSize) {
    this.blockPos = _blockPos;
    this.blockSize = _blockSize;
    if(!gameStarted) { this.blockPos = randomStarPos(); }
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
    blockPos.x -= 400*(millis()-lastMove)*0.001;
    lastMove = millis();
    if(blockPos.x < -1) {
      blockPos.x = random(width+2, width*2);
    }
    display();
  }
  
  PVector randomStarPos() {
    return new PVector(random(-width/2, width*1.5), random(height/4, height - height/4));
  }
}
