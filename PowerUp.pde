class PowerUp {
  float x, y;
  int size = 10;
  int speed = 50;
  int lastMove, type;
  
  PowerUp(float _x, float _y, int _size) {
    this.x = _x;
    this.y = _y;
    this.size = _size/2;
    this.lastMove = millis();
    this.type = ceil(random(0,4));
  }
  
  void update() {
    if(!gamePaused) {
      y += speed*((millis()-lastMove)*0.001);
      lastMove = millis();
      if(checkCollision()) {
        powerUps.remove(this);
      }
    }
    drawPowerUp();
  }
  
  void drawPowerUp() {
    if(type == 1) {
      ellipse(x, y, size, size);
    }
    if(type == 2) {
      rect(x - 5, y - 5, size, size);
    }
    if(type == 3) {
      triangle(x - size/2, y + size/2, x + size/2, y + size/2, x, y - size/2);
    }
    if(type == 4) {
      rect(x - 5, y - 5, 10, 10);
    }
  }
  
  boolean checkCollision() {
    for(int i = players.size() - 1; i > -1; i--) {
      if(!players.get(i).isDead) {
        if((y > players.get(i).y - players.get(i).pHeight - players.get(i).pHeight/3 && y < players.get(i).y + players.get(i).pHeight)) {
          if((x > players.get(i).x && x < players.get(i).x + players.get(i).pWidth)) {
            //players.get(i).activatePowerUp();
            return true;
          }
        }
      }
    }
    return false;
  }
}
