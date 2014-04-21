class Player {
  float x, y;
  int speed = 50;
  int lastMove;
  int left = 0;
  int right = 0;
  int pWidth = 20;
  
  Player(int x) {
    this.x = x;
    y = height - pWidth/2;
  }
  
  void update() {
    x += (right - left) * (speed*(millis()-lastMove)*0.003);
    
    if(x <= pWidth/2) {
      x = pWidth/2;
    }
    if(x >= width - pWidth/2) {
      x = width - pWidth/2;
    }
    
    lastMove = millis();
    display();
  }
  
  void display() {
    noStroke();
    fill(0, 255, 0);
    triangle(x - pWidth/2 , y, x, y - pWidth, x + pWidth/2, y);
  }
  
  void keyDown() {
    if(keyPressed) {
      if(key == CODED && isMultiplayer) {
        if(keyCode == LEFT) { players.get(1).left = 1; }
        if(keyCode == RIGHT) { players.get(1).right = 1; }
        if(keyCode == CONTROL) {
          shoot(players.get(1).x, players.get(1).y, players.get(1).pWidth, -1);
        }
      }
      if(key == 'a' || key == 'A') { players.get(0).left = 1; }
      if(key == 'd' || key == 'D') { players.get(0).right = 1; }
      if(key == ' ') {
        shoot(players.get(0).x, players.get(0).y, players.get(0).pWidth, -1);
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
