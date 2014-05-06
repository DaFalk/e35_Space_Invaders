class Block {
  PVector blockPos;
  PVector deathPos;
  Enemy owner;
  int blockSize;
  int lastMove;
  float speed, velocity;
  color bFill;
  
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
    fill(bFill);
    if(deathPos != null) { releaseBlock(); }
    rect(blockPos.x, blockPos.y, blockSize, blockSize);
    if(checkCollision()) { enemies.remove(owner); }
  }
  
//Apply gravity to block.
  void releaseBlock() {
    int flip;
    if(blockPos.x < deathPos.x) { flip = -1; }
    else { flip = 1; }
    float angle = atan2(deathPos.y - blockPos.y, deathPos.x - blockPos.x);
    blockPos.x += velocity*(millis()-lastMove)*0.001*cos(angle);
    blockPos.y += velocity*(millis()-lastMove)*0.001;
    velocity += velocity*(millis()-lastMove)*0.001;  
    
    lastMove = millis();
  }
  
  boolean checkCollision() {
  //Check if enemy shot collides with a player
    for(int i = players.size() - 1; i > -1; i--) {
      Player _player = players.get(i);
      if(!_player.isDead) {
        if((blockPos.y > _player.y - _player.pHeight - _player.pHeight/3 && blockPos.y < _player.y + _player.pHeight)) {
          if((blockPos.x > _player.x && blockPos.x < _player.x + _player.pWidth)) {
            if(_player.hasShield) { _player.hasShield = false; }
            else { _player.adjustLifes(); }
            return true;
          }
        }
      }
    }
    return false;
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
