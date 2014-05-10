class Block {
  PVector blockPos;
  PVector deathPos;
  Enemy owner;
  int blockSize;
  int blockDir = 1;
  int lastMove;
  float speed;
  float velocity = 0.0125*width;
  float gravity = 0.025*width;
  color bFill;
  float currentAlpha = 255;
  
  Block(PVector _blockPos, int _blockSize) {
    blockPos = _blockPos;
    blockSize = _blockSize;
    deathPos = deathPos;
    speed = 200;
    if(!gameStarted) { this.blockPos = randomStarPos(); }
  }
  
  void display() {
    rectMode(CENTER);
    noStroke();
    fill(bFill, currentAlpha);
    if(deathPos != null) {
      if(!gamePaused) {
        if(blockDir < 0) { implode(); }
        else { explode(); }
        lastMove = millis();
        if(owner == null) {
          if(blockPos.y > height) { ground.blocks.remove(this); }
        }
      }
      else {
        //Adjust lastMove to pause blocks
        lastMove += millis() - lastMove;
      }
    }
    rect(blockPos.x, blockPos.y, blockSize, blockSize);
  }
   
//Move towards deathPos x and affect deathPos y by gravity (forms a new projectile).
  void implode() {
    float angle = atan2(blockPos.y - deathPos.y, blockPos.x - deathPos.x);
    
    //Add velocity to block position and adjust velocity.
    blockPos.add(new PVector(-timeFix(velocity, lastMove)*cos(angle), timeFix(velocity, lastMove)));
    velocity += timeFix(velocity, lastMove);
    gravity += timeFix(gravity, lastMove);
  }
   
//Move away from deathPos x and y.
  void explode() {
    float angle = atan2(blockPos.y - deathPos.y, blockPos.x - deathPos.x);
    float _velX = timeFix(velocity*5, lastMove);
    float _velY = timeFix(velocity*5, lastMove)*sin(angle);
    if(owner == null) {
      _velX = timeFix(velocity*2.5, lastMove);
      _velY = timeFix(velocity*random(5, 10), lastMove)*sin(angle) + timeFix(gravity, lastMove);
    }
    
    //Add velocity to block position and adjust velocity.
    blockPos.add(new PVector((_velX*cos(angle))*blockDir, _velY));
    velocity -= timeFix(velocity, lastMove);
    gravity += timeFix(gravity, lastMove);
  }
  
//Used to move the stars in the startmenu.
  void moveBlock() {
    blockPos.x -= timeFix(400, lastMove);
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
