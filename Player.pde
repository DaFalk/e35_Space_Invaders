class Player {
  String hp;
  float x, y;
  int lastMove, lastShot, shotCooldown, left, right, lifes, pHeight;
  int pWidth = 40;
  int speed = 150;
  boolean isDead = false;
  
  Player(int x) {
    this.hp = "LIFES";
    this.x = x - pWidth/2;
    this.lifes = 3;
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
    displayLifes();
  }
  
  void drawPlayer(float px, float py) {
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
  
  void attack(int player) {
    if(millis() >= lastShot + shotCooldown) {
      shoot(players.get(player).x + pWidth/2, players.get(player).y, players.get(player).pHeight, -1);
      shotCooldown = 1500;
      lastShot = millis();
    }
  }
  
  void displayLifes() {
    String numPlayer = "P" + nf(players.indexOf(this), 0);
    if(!isDead && lifes > 0) { fill(255); }
    else { fill(255, 0, 0, 220); }
    textAlign(LEFT, CENTER);
    text(hp, (pWidth/2)*(1-players.indexOf(this)) + (width - pWidth/2 - textWidth(hp))*players.indexOf(this), pWidth);
    for(int i = 0; i < lifes; i++) {
      drawPlayer((textWidth(hp) + pWidth + (pWidth*1.5)*i)*(1-players.indexOf(this)) + (width - pWidth*2 - textWidth(hp) - (pWidth*1.5)*i)*players.indexOf(this), pWidth);
    }
  }
  
  void adjustLifes() {
    lifes--;
    isDead = true;
    if(lifes > 0) {
      respawn();
    }
    else {
      hp = "DEAD";
    }
  }
  
  void respawn() {
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
