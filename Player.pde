class Player {
  float x, y;
  int lastMove, lastShot, shotCooldown, left, right;
  int speed = 150;
  int pWidth = 20;
  
  Player(int x) {
    this.x = x;
    y = height - pWidth/2;
  }
  
  void update() {
    x += (right - left) * (speed*(millis()-lastMove)*0.001);
    lastMove = millis();
    checkCollision();
    display();
  }
  
  void display() {
    noStroke();
    fill(0, 255, 0);
    triangle(x - pWidth/2 , y, x, y - pWidth, x + pWidth/2, y);
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
      shoot(players.get(player).x, players.get(player).y, players.get(player).pWidth, -1);
      shotCooldown = 1500;
      lastShot = millis();
    }
  }
  
  void keyDown() {
    if(keyPressed) {
      if(key == CODED && isMultiplayer) {
        if(keyCode == LEFT) { players.get(1).left = 1; }
        if(keyCode == RIGHT) { players.get(1).right = 1; }
        if(keyCode == CONTROL) {
          attack(1);
        }
      }
      if(key == 'a' || key == 'A') { players.get(0).left = 1; }
      if(key == 'd' || key == 'D') { players.get(0).right = 1; }
      if(key == ' ') {
        attack(0);
      }
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
