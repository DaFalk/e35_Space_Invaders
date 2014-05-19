// This class draws a single block that can be affected in different ways on impact.
// The ground, covers and the enemies are made out of these blocks to add impact effects.
//

class Block {
  PVector blockPos, deathPos;
  Enemy owner;
  ArrayList<Block> home;  //The array list to remove from.
  int blockSize;
  int blockDir = 1;
  int lastMove;
  float speed = 200;
  float velocity = dynamicValue(10);
  float gravity = dynamicValue(20);
  float currentAlpha = 255;
  color bFill;
  boolean broken = false;
  
  Block(PVector _blockPos, int _blockSize) {
    blockPos = _blockPos;
    blockSize = _blockSize;
    if(!gameStarted) { this.blockPos = randomStarPos(); }  //Random position for the start menu stars.
  }
  
  void display() {
    noStroke();
    fill(bFill, currentAlpha);
    
    //When blocks are given a death position, a "death" behaviour is triggered.
    if(deathPos != null) {
      if(!gamePaused) {
        //BlockDir controls how the block will behave.
        if(blockDir < 0) { implode(); }
        else { explode(); }
        
        lastMove = millis();  //Both implode() and explode() uses lastMove.
        
        //Remove ground blocks when they are above height.
        if(owner == null) {
          if(blockPos.y > height) { home.remove(this); }
        }
      }
      else { lastMove += millis() - lastMove; }  //Adjust lastMove to pause blocks.
    }
    
    rect(blockPos.x, blockPos.y, blockSize, blockSize);
  }
   
//Move towards deathPos x and affect deathPos y by gravity (forms a new projectile).
  void implode() {
    float angle = atan2(blockPos.y - deathPos.y, blockPos.x - deathPos.x);
    
    //Add velocity to block position and adjust velocity and gravity.
    blockPos.add(new PVector(-timeFix(velocity, lastMove)*cos(angle), timeFix(velocity, lastMove)));
    //Calculate timefixed velocity.
    velocity += timeFix(velocity, lastMove);
    gravity += timeFix(gravity, lastMove);
  }
   
//Move away from deathPos x and y.
  void explode() {
    float angle = atan2(blockPos.y - deathPos.y, blockPos.x - deathPos.x);  //Get angle from death position to block position.
    //Calculate timefixed velocity.
    float _velX = timeFix(velocity*5, lastMove);
    float _velY = timeFix(velocity*5, lastMove)*sin(angle);
    
    //If block is from ground trigger physics-like behaviour.
    if(owner == null) {
      //Calculate timefixed velocity.
      _velX = timeFix(velocity*2.5, lastMove);  //X velocity away from impact.
      _velY = timeFix(velocity*random(5, 10), lastMove)*sin(angle) + timeFix(gravity, lastMove);  //Y velocity away from impact add increasing gravity.
    }
    
    //Add velocity to block position and adjust velocity.
    blockPos.add(new PVector((_velX*cos(angle))*blockDir, _velY));
    //Decrease velocity and increase gravity.
    velocity -= timeFix(velocity, lastMove);
    gravity += timeFix(gravity, lastMove);
  }
  
//Used to move the stars in the startmenu.
  void moveBlock() {
    blockPos.x -= timeFix(400, lastMove);
    lastMove = millis();
    //If block goes off screen to the left give it a random off screen position to the right. 
    if(blockPos.x < -1) { blockPos.x = random(width+2, width*2); }
  }
  
  //Random position likely on the screen (buffer to avoid patterned space).
  PVector randomStarPos() {
    return new PVector(random(-width/2, width*1.5), random(height/4, height - height/4));
  }
}
