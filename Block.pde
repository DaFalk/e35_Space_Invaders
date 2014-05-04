class Block {
  PVector blockPos;
  PVector deathPos;
  int blockSize;
  int lastMove, speed;
  color bFill;
  
  Block(PVector _blockPos, int _blockSize) {
    this.blockPos = _blockPos;
    this.blockSize = _blockSize;
    this.speed = 200;
    if(!gameStarted) { this.blockPos = randomStarPos(); }
  }
  
  void display() {
    rectMode(CENTER);
    noStroke();
    fill(bFill);
    if(deathPos != null) { releaseBlock(); }
    rect(blockPos.x, blockPos.y, blockSize, blockSize);
  }
  
  void releaseBlock() {
    int flip;
    if(blockPos.x < deathPos.x) { flip = -1; }
    else { flip = 1; }
    float angle = atan2(deathPos.y - cover.groundY, deathPos.x + 100*flip);
    blockPos.x += (cos(angle)*speed)*(millis()-lastMove)*0.001;
    blockPos.y += 96*(millis()-lastMove)*0.001;
    angle = angle*0.9;
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
