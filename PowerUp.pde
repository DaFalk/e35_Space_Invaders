class PowerUp {
  float x, y;
  int speed = 50;
  int lastMove;
  
  PowerUp(float _x, float _y) {
    this.x = _x;
    this.y = _y;
    this.lastMove = millis();
  }
  
  void update() {
    y += speed*((millis()-lastMove)*0.001);
    lastMove = millis();
    if(checkCollision()) {
      powerUps.remove(this);
    }
    drawPowerUp();
  }
  
  void drawPowerUp() {
    ellipse(x, y, 10, 10);
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
