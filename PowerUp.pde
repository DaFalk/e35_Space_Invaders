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
    this.type = ceil(random(0, 4));
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
<<<<<<< HEAD
      fill(0, 0, 255);
      triangle(x - size/2, y - size/2, x + size/2, y - size/2, x, y + size/2);
    }
=======
      ellipse(x, y, size, size);
    }
    if(type == 2) {
      rect(x - 5, y - 5, size, size);
    }
//    if(type == 3) {
//      triangle(x - size/2, y + size/2, x + size/2, y + size/2, x, y - size/2);
//    }
//    if(type == 4) {
//      rect(x - 5, y - 5, 10, 10);
//    }
>>>>>>> e14357bcadce6ea602ea398989df5216f091aeca
  }
  
  boolean checkCollision() {
    for(int i = players.size() - 1; i > -1; i--) {
      Player _player = players.get(i);
      if(!_player.isDead) {
        if((y > _player.y - (_player.pHeight/3)*2 && y < _player.y + _player.pHeight)) {
          if((x > _player.x && x < _player.x + _player.pWidth)) {
            _player.weaponType = type;
            _player.powerUpStartTime = millis();
            return true;
          }
        }
      }
    }
    return false;
  }
}
