class Player {
  float x, y;
  int lastMove, lastShot, shotCooldown, left, right, lifes, pHeight;
  int pWidth = 40;
  int speed = 150;
  boolean isDead = false;
  
  Player(int x) {
    this.x = x - pWidth/2;
    this.lifes = 3;
    y = height - pWidth/2;
    pHeight = pWidth/4;
  }
  
  void update() {
    x += (right - left) * (speed*(millis()-lastMove)*0.001);
    lastMove = millis();
    checkCollision();
    drawPlayer();
  }
  
  void drawPlayer() {
    noStroke();
    fill(0, 255, 0);
    //Body
    rect(x, y, pWidth, pHeight);
    rect(x + (pWidth - pWidth*0.85)/2, y - pHeight/3, pWidth*0.85, pHeight/3);
    //Canon
    rect(x + pWidth/2.5, y - pWidth/5, pWidth/5, pWidth/5);
    rect(x + pWidth*(0.5 - (0.075/2)), y - pWidth/3.5, pWidth*0.075, pWidth/3.5);
  }
  
  void checkCollision() {
    if(x <= pWidth/2) {
      x = pWidth/2;
    }
    if(x >= width - pWidth/2) {
      x = width - pWidth/2;
    }
  }
  
  void attack(int player) {
    if(millis() >= lastShot + shotCooldown) {
      shoot(players.get(player).x + pWidth/2, players.get(player).y, players.get(player).pHeight, -1);
      shotCooldown = 1500;
      lastShot = millis();
    }
  }
  
  void keyDown() {
    if(keyPressed) {
      if(key == CODED && isMultiplayer) {
        if(keyCode == LEFT) { players.get(1).left = 1; }
        if(keyCode == RIGHT) { players.get(1).right = 1; }
        if(keyCode == CONTROL) { attack(1); }
      }
      if(key == 'a' || key == 'A') { players.get(0).left = 1; }
      if(key == 'd' || key == 'D') { players.get(0).right = 1; }
      if(key == ' ') { attack(0); }
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
