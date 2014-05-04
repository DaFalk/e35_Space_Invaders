class PowerUp {
  float x, y;
  float size;
  float speed = 50;
  int duration, lastMove, type, shotCooldown;
  
  PowerUp(float _x, float _y, float _size) {
    this.x = _x;
    this.y = _y;
    this.size = _size*0.75;
    this.lastMove = millis();
    this.type = ceil(random(0, 4));
    this.duration = type*5000;
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
    noStroke();
    fill(0, 255, 0);
    triangle(x - size/2, y - size/2, x + size/2, y - size/2, x, y + size/2);
    stroke(0, 255, 0);
    noFill();
    ellipse(x, y, size, size);
    strokeWeight(3);
    if(type == 1) { stroke(color(70, 110, 255, 155)); }
    if(type == 2) { stroke(color(255, 155)); }
    if(type == 3) { stroke(color(255, 70, 110, 155)); }
    if(type == 4) { stroke(color(0, 255, 0, 155)); }
    ellipse(x, y, size*2, size*2);
  }
  
  boolean checkCollision() {
    for(int i = players.size() - 1; i > -1; i--) {
      Player _player = players.get(i);
      if(!_player.isDead) {
        if((y > _player.y - (_player.pHeight/3)*2 && y < _player.y + _player.pHeight)) {
          if((x > _player.x && x < _player.x + _player.pWidth)) {
            _player.setWeaponStats(type);
            return true;
          }
        }
      }
    }
    return false;
  }
}
