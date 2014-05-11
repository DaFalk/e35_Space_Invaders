class Player {
  String lifesLabel = "LIFES";
  float x, y;
  int lastMove, lastShot, shotCooldown, left, right;
  int weaponType, powerUpStartTime, powerUpDuration;
  int lifes = 3;
  int score = 0;
  float pWidth = 0.05*width;
  float pHeight = 0.0125*width;
  float speed = 0.1875*width;
  boolean attack = false;
  boolean isDead = false;
  boolean hasShield = false;
  
  Player(float xPos) {
    x = xPos;
    y = height - pWidth;
    weaponType = 0;
    shotCooldown = 1000;
  }
  
  void update() {
    if(!isDead) {
      if(!gamePaused) {
        x += (right - left) * timeFix(speed, lastMove);
        lastMove = millis();
        checkCollision();
        if(attack) { shoot(); }
        handlePowerUp();
      }
      drawPlayer(x, y, 1, true);
    }
  }
  
//Draw player and shield if this drawn player is active.
  void drawPlayer(float _x, float _y, float _scale, boolean _active) {
    rectMode(CORNER);
    noStroke();
    float _pWidth = pWidth*_scale;
    float _pHeight = pHeight*_scale;
    fill(0, 255, 0);
    //Body
    rect(_x, _y, _pWidth, _pHeight);
    rect(_x + (_pWidth - _pWidth*0.85)/2, _y - _pHeight/3, _pWidth*0.85, _pHeight/3);
    //Canon
    rect(_x + _pWidth/2.5, _y - _pWidth/5, _pWidth/5, _pWidth/5);
    rect(_x + _pWidth*(0.5 - (0.075/2)), _y - _pWidth/3.5, _pWidth*0.075, _pWidth/3.5);
    
    if(_active) {
      if(hasShield) {
        fill(200, 200, 255,100);
        ellipse(_x + _pWidth/2, _y + _pHeight/3, _pWidth*1.4, _pWidth*0.85);
      }
    }
  }
  
//Keep player within bounds.
  void checkCollision() {
    if(x <= 0) { x = 0; }
    if(x >= width - pWidth) { x = width - pWidth; }
  }
  
//Trigger a shot of current weapon type.
  void shoot() {
    if(millis() - lastShot >= shotCooldown) {
      Shot s = new Shot(new PVector(x + pWidth/2, y - pHeight), weaponType, players.indexOf(this));
      shots.add(s);
      lastShot = millis();
    }
  }
  
//Subtract life and check if player is dead.
  void adjustLifes() {
    lifes--;
    weaponType = 0;
    if(lifes > 0) { spawner.respawnPlayer(this); }
    else {
      isDead = true;
      lifesLabel = "DEAD";
      menUI.calcAllLifes();
    }
  }
  
//Manage powerup duration and ajdust weapon type.
  void handlePowerUp() {
    if(weaponType != 0) {
      if(millis() >= powerUpStartTime + powerUpDuration) {
        weaponType = 0;
        shotCooldown = 1000;
      }
    }
  }
  
  void keyDown() {
    if(key == 'a' || key == 'A') { left = 1; }
    if(key == 'd' || key == 'D') { right = 1; }
    if(key == ' ') { attack = true; }
    if(keyCode == LEFT) { left = 1; }
    if(keyCode == RIGHT) { right = 1; }
    if(keyCode == UP) { attack = true; }
    
    //for testing purpose only :)
    switch(key) {
    case('0'):
      hasShield = true;
    break;
    case('1'):
      weaponType = 1;
      shotCooldown = 2000;
      powerUpDuration = 5000;
      powerUpStartTime = millis();
      lastShot = millis();
    break;
    case('2'):
      weaponType = 2;
      shotCooldown = 100;
      powerUpDuration = 4000;
      powerUpStartTime = millis();
      lastShot = millis();
    break;
    case('3'):
      weaponType = 3;
      shotCooldown = 1000;
      powerUpDuration = 4000;
      powerUpStartTime = millis();
      lastShot = millis();
    break;
    case('4'):
      weaponType = 4;
      shotCooldown = 500;
      powerUpDuration = 4000;
      powerUpStartTime = millis();
      lastShot = millis();
    break;
    case('e'):
      if(!isDead) { adjustLifes(); }
    break;
    }
  }
  
  void keyUp() {
    if(key == 'a' || key == 'A') { left = 0; }
    if(key == 'd' || key == 'D') { right = 0; }
    if(key == ' ') { attack = false; }
    if(keyCode == LEFT) { left = 0; }
    if(keyCode == RIGHT) { right = 0; }
    if(keyCode == UP) { attack = false; }
  }
}
