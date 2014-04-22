class Player {
  String scoreText = "SCORE";
  String pLifes;
  float x, y;
  int lastMove, lastShot, shotCooldown, left, right, lifes, pHeight;
  int pWidth = 40;
  int speed = 150;
  int score = 0;
  boolean isDead = false;
  
  Player(int xPos) {
    this.pLifes = "LIFES";
    this.x = xPos - pWidth/2;
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
      shoot(players.get(player).x + pWidth/2, players.get(player).y, players.get(player).pHeight, -1, players.indexOf(this));
      shotCooldown = 1500;
      lastShot = millis();
    }
  }
  
  void displayLifes() {
    String numPlayer = "P" + nf(players.indexOf(this)+1, 0);
    String pts = nf(score, 0);
    if(lifes > 0) { fill(255); }
    else { fill(255, 0, 0, 220); }
    textAlign(LEFT, CENTER);
    textSize(62);
    float tx = pHeight/2;
    text(numPlayer, tx*(1-players.indexOf(this)) + (width - tx - textWidth(numPlayer))*players.indexOf(this), pWidth/2);
    tx += textWidth(numPlayer);
    textSize(textHeight);
    text(pLifes, tx*(1-players.indexOf(this)) + (width - tx - textWidth(pLifes))*players.indexOf(this), pWidth);
    text(scoreText, tx*(1-players.indexOf(this)) + (width - tx - textWidth(scoreText))*players.indexOf(this), pWidth - textHeight*1.25);
    tx += textWidth(pLifes) + pWidth/4;
    text(pts, (tx + pWidth*1.75 - textWidth(pts)/2)*(1-players.indexOf(this)) + (width - tx - textWidth(pts)/2 - pWidth*2)*players.indexOf(this), pWidth - textHeight*1.25);
    for(int i = 0; i < lifes; i++) {
      drawPlayer((tx + (pWidth*1.25)*i)*(1-players.indexOf(this)) + (width - tx - pWidth - (pWidth*1.5)*i)*players.indexOf(this), pWidth);
    }
  }
  
  void adjustLifes() {
    lifes--;
    if(lifes > 0) {
      respawn();
    }
    else {
      isDead = true;
      pLifes = "DEAD";
    }
  }
  
  void adjustScore() {
    score += 10;
  }
  
  void respawn() {
    x = width/(2+players.indexOf(this)) - ((width/2 - width/3)*(players.size()-1))*(1-players.indexOf(this)) + (width/(2+players.indexOf(this)))*players.indexOf(this);
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
