class Block {
  PVector blockPos;
  PVector deathPos;
  Enemy owner;
  int blockSize;
  int blockDir = 1;
  int lastMove;
  float speed, velocity;
  color bFill;
  float currentAlpha = 255;
  
  Block(PVector _blockPos, int _blockSize) {
    blockPos = _blockPos;
    blockSize = _blockSize;
    deathPos = deathPos;
    speed = 200;
    velocity = 9.6;
    if(!gameStarted) { this.blockPos = randomStarPos(); }
  }
  
  void display() {
    rectMode(CENTER);
    noStroke();
    fill(bFill, currentAlpha);
    if(deathPos != null) {
      if(!gamePaused) { releaseBlock(); }
      else { lastMove += millis() - lastMove; }
    }
    rect(blockPos.x, blockPos.y, blockSize, blockSize);
  }
   
//Apply gravity to block.
  void releaseBlock() {
    int velocityX = 1;
    float spread = 1;
    float angle = atan2(deathPos.y - blockPos.y, deathPos.x - blockPos.x);
    
    //Explode if direction is above 1 otherwise implode.
    if(blockDir > 0) {
      velocityX = 5;
      spread = -sin(angle);
    }
    //Add velocity to block x and y and readjust velocity.
    blockPos.x -= ((velocity*velocityX)*(millis()-lastMove)*0.001*cos(angle))*blockDir;
    blockPos.y += (velocity*velocityX)*(millis()-lastMove)*0.001*spread;
    velocity += (velocity*(millis()-lastMove)*0.001)*(blockDir*-1);
    lastMove = millis();
  }
  
//Used to move the stars in the startmenu.
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
