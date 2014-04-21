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
        if(keyCode == LEFT) { player2.left = 1; }
        if(keyCode == RIGHT) { player2.right = 1; }
        if(keyCode == CONTROL) {
          shoot(player2.x, player2.y, player2.pWidth, -1);
        }
      }
      if(key == 'a' || key == 'A') { player1.left = 1; }
      if(key == 'd' || key == 'D') { player1.right = 1; }
      if(key == ' ') {
        shoot(player1.x, player1.y, player1.pWidth, -1);
      }
    }
  }
  
  void keyUp() {
    if(key == CODED && isMultiplayer) {
      if(keyCode == LEFT) { player2.left = 0; }
      if(keyCode == RIGHT) { player2.right = 0; }
    }
    if(key == 'a' || key == 'A') { player1.left = 0; }
    if(key == 'd' || key == 'D') { player1.right = 0; }
  }
}
