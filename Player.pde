class Player {
  String lifesLabel;
  float x, y;
  int lastMove, lastShot, shotCooldown, left, right, lifes, pHeight;
  int pWidth = 40;
  int speed = 150;
  int score = 0;
  int weaponType;
  int powerUpStartTime;
  int powerUpDuration = 4000;
  boolean isDead = false;
  
  Player(int xPos) {
    this.lifesLabel = "LIFES";
    this.x = xPos - pWidth/2;
    this.lifes = 3;
    this.shotCooldown = 1500;
    this.weaponType = 0;
    y = height - pWidth/2;
    pHeight = pWidth/4;
  }
  
  void update() {
    if(!isDead && !gamePaused) {
      x += (right - left) * (speed*(millis()-lastMove)*0.001);
      lastMove = millis();
      checkCollision();
      handlePowerUp();
      drawPlayer(x, y);
    }
  }
  
  void drawPlayer(float px, float py) {
    rectMode(CORNER);
    noStroke();
    fill(0, 255, 0);
    //Body
    rect(px, py, pWidth, pHeight);
    rect(px + (pWidth - pWidth*0.85)/2, py - pHeight/3, pWidth*0.85, pHeight/3);
    //Canon
    rect(px + pWidth/2.5, py - pWidth/5, pWidth/5, pWidth/5);
    rect(px + pWidth*(0.5 - (0.075/2)), py - pWidth/3.5, pWidth*0.075, pWidth/3.5);
  }
  
  void checkCollision() {
    if(x <= pWidth/2) {
      x = pWidth/2;
    }
    if(x >= width - pWidth/2) {
      x = width - pWidth/2;
    }
  }
  
  void attack() {
    if(millis() >= lastShot + shotCooldown) {
      Shot s = new Shot(x + pWidth/2, y - pHeight, -1, weaponType, players.indexOf(this));
      shots.add(s);
      lastShot = millis();
    }
  }
  
  void adjustLifes() {
    lifes--;
    if(lifes > 0) {
      spawner.respawnPlayer(this);
    }
    else {
      isDead = true;
      lifesLabel = "DEAD";
    }
  }
  
  void adjustScore() {
    score += 10;
  }
  
  void handlePowerUp() {
    if(weaponType != 0) {
      if(millis() >= powerUpStartTime + powerUpDuration) {
        weaponType = 0;
        shotCooldown = 1500;
      }
    }
  }
  
  void keyDown() {
    if(keyPressed) {
      if(keyCode == LEFT) { left = 1; }
      if(keyCode == RIGHT) { right = 1; }
      if(keyCode == CONTROL) { attack(); }
      if(key == 'a' || key == 'A') { left = 1; }
      if(key == 'd' || key == 'D') { right = 1; }
      if(key == ' ') { attack(); }
    }
  }
  
  void keyUp() {
    if(keyCode == LEFT) { left = 0; }
    if(keyCode == RIGHT) { right = 0; }
    if(key == 'a' || key == 'A') { left = 0; }
    if(key == 'd' || key == 'D') { right = 0; }
  }
}
