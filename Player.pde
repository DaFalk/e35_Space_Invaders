class Player {
  String lifesLabel;
  float x, y;
  int lastMove, lastShot, shotCooldown, left, right, lifes, pHeight;
  int pWidth = 40;
  int speed = 150;
  int score = 0;
  boolean attack;
  int weaponType;
  int powerUpStartTime;
  int powerUpDuration;
  boolean isDead = false;
  
  Player(int xPos) {
    this.lifesLabel = "LIFES";
    this.x = xPos - pWidth/2;
    this.lifes = 3;
    this.attack = false;
    this.shotCooldown = 1500;
    this.weaponType = 0;
    y = height - pWidth;
    pHeight = pWidth/4;
  }
  
  void update() {
    if(!isDead && !gamePaused) {
      x += (right - left) * (speed*(millis()-lastMove)*0.001);
      lastMove = millis();
      checkCollision();
      if(attack) { shoot(); }
      handlePowerUp();
      drawPlayer(x, y);
    }
  }
  
  void drawPlayer(float _x, float _y) {
    rectMode(CORNER);
    noStroke();
    fill(0, 255, 0);
    //Body
    rect(_x, _y, pWidth, pHeight);
    rect(_x + (pWidth - pWidth*0.85)/2, _y - pHeight/3, pWidth*0.85, pHeight/3);
    //Canon
    rect(_x + pWidth/2.5, _y - pWidth/5, pWidth/5, pWidth/5);
    rect(_x + pWidth*(0.5 - (0.075/2)), _y - pWidth/3.5, pWidth*0.075, pWidth/3.5);
  }
  
  void checkCollision() {
    if(x <= 0) { x = 0; }
    if(x >= width - pWidth) {
      x = width - pWidth;
    }
  }
  
  void shoot() {
    if(weaponType != 2) {
      if(millis() >= lastShot + shotCooldown) {
        Shot s = new Shot(x + pWidth/2, y - pHeight, weaponType, players.indexOf(this));
        shots.add(s);
        lastShot = millis();
      }
    }
    else {
      if(shots.size() == 0) {
        Shot s = new Shot(x + pWidth/2, y - pHeight, weaponType, players.indexOf(this));
        shots.add(s);
      }
    }
  }
  
  void adjustLifes() {
    lifes--;
    if(lifes > 0) { spawner.respawnPlayer(this); }
    else {
      isDead = true;
      lifesLabel = "DEAD";
    }
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
    if(key == 'a' || key == 'A') { left = 1; }
    if(key == 'd' || key == 'D') { right = 1; }
    if(key == ' ') { attack = true; }
    if(keyCode == LEFT) { left = 1; }
    if(keyCode == RIGHT) { right = 1; }
    if(keyCode == CONTROL) { attack = true; }
  }
  
  void keyUp() {
    if(key == 'a' || key == 'A') { left = 0; }
    if(key == 'd' || key == 'D') { right = 0; }
    if(key == ' ') { attack = false; }
    if(keyCode == LEFT) { left = 0; }
    if(keyCode == RIGHT) { right = 0; }
    if(keyCode == CONTROL) { attack = false; }
  }
}
