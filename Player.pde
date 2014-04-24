class Player {
  String lifesLabel;
  float x, y;
  int lastMove, lastShot, shotCooldown, left, right, lifes, pHeight;
  int pWidth = 40;
  int speed = 150;
  int score = 0;
  boolean isDead = false;
  
  Player(int xPos) {
    this.lifesLabel = "LIFES";
    this.x = xPos - pWidth/2;
    this.lifes = 3;
    this.shotCooldown = 1500; //If we want to add upgrades, boosts or other weapon affectors
    y = height - pWidth/2;
    pHeight = pWidth/4;
  }
  
  void update() {
    if(!isDead) {
      x += (right - left) * (speed*(millis()-lastMove)*0.001);
      lastMove = millis();
      checkCollision();
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
      Shot s = new Shot(x + pWidth/2, y - pHeight, -1, players.indexOf(this));
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
  
  void keyDown() {
    if(keyPressed) {
      if(key == CODED && isMultiplayer) {
        if(keyCode == LEFT) { players.get(1).left = 1; }
        if(keyCode == RIGHT) { players.get(1).right = 1; }
        if(keyCode == CONTROL) { attack(); }
      }
      if(key == 'a' || key == 'A') { players.get(0).left = 1; }
      if(key == 'd' || key == 'D') { players.get(0).right = 1; }
      if(key == ' ') { attack(); }
    }
  }
  
  void keyUp() {
    if(key == CODED && isMultiplayer) {
      if(keyCode == LEFT) { players.get(1).left = 0; }
      if(keyCode == RIGHT) { players.get(1).right = 0; }
    }
    if(key == 'a' || key == 'A') { players.get(0).left = 0; }
    if(key == 'd' || key == 'D') { players.get(0).right = 0; }
  }
}
