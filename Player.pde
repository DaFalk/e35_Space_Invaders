class Player {
  String lifesLabel = "LIFES";
  float x, y;
  int lastMove, lastShot, shotCooldown, left, right, pHeight;
  int lifes = 3;
  int pWidth = 40;
  int speed = 150;
  int score = 0;
  int weaponType, powerUpStartTime, powerUpDuration;
  boolean attack = false;
  boolean isDead = false;
  boolean hasShield = false;
  
  Player(float xPos) {
    x = xPos;
    y = height - pWidth;
    pHeight = pWidth/4;
    weaponType = 0;
    shotCooldown = 1000;
  }
  
  void update() {
    if(!isDead) {
      if(!gamePaused) {
        x += (right - left) * (speed*(millis()-lastMove)*0.001);
        lastMove = millis();
        checkCollision();
        if(attack) { shoot(); }
        handlePowerUp();
      }
      drawPlayer(x, y, true);
    }
  }
  
//Draw player and shield if this drawn player is active.
  void drawPlayer(float _x, float _y, boolean _active) {
    rectMode(CORNER);
    noStroke();
    fill(0, 255, 0);
    //Body
    rect(_x, _y, pWidth, pHeight);
    rect(_x + (pWidth - pWidth*0.85)/2, _y - pHeight/3, pWidth*0.85, pHeight/3);
    //Canon
    rect(_x + pWidth/2.5, _y - pWidth/5, pWidth/5, pWidth/5);
    rect(_x + pWidth*(0.5 - (0.075/2)), _y - pWidth/3.5, pWidth*0.075, pWidth/3.5);
    
    if(_active) {
      if(hasShield) {
        fill(200, 200, 255,100);
        ellipse(_x + pWidth/2, _y + pHeight/3, pWidth*1.4, pWidth*0.85);
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
    
    //testing purpose
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
      powerUpDuration = 3000;
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
      adjustLifes();
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
