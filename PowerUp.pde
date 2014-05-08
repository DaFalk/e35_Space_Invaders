//
//
// Accesses Player class

class PowerUp {
  PVector powerUpPos;
  float size;
  float speed = 0.0625*width;
  int lastMove, type, shotCooldown;
  
  PowerUp(PVector _pos, float _size) {
    powerUpPos = _pos;
    this.size = _size*0.75;
    this.lastMove = millis();
    this.type = ceil(random(-1, 4));
  }
  
  void update() {
    if(!gamePaused) {
      powerUpPos.y += speed*((millis()-lastMove)*0.001);
      lastMove = millis();
      if(checkCollision()) { powerUps.remove(this); }
    }
    drawPowerUp();
  }
  
//Draw powerup icon and color according to type.
  void drawPowerUp() {
    noStroke();
    fill(0, 255, 0);
    triangle(powerUpPos.x - size/2, powerUpPos.y - size/2, powerUpPos.x + size/2, powerUpPos.y - size/2, powerUpPos.x, powerUpPos.y + size/2);
    stroke(0, 255, 0);
    strokeWeight(0.0025*width);
    noFill();
    ellipse(powerUpPos.x, powerUpPos.y, size, size);
    strokeWeight(0.00375*width);
    switch(type) {
      case(0):
        stroke(255, 100);
        ellipse(powerUpPos.x, powerUpPos.y, size*3, size*3);
        stroke(255, 155);
        break;
      case(1):
        stroke(70, 110, 255, 155);
      break;
      case(2):
        stroke(255, 155);
      break;
      case(3):
        stroke(255, 70, 110, 155);
      break;
      case(4):
        stroke(0, 255, 0, 155);
      break;
    }
    ellipse(powerUpPos.x, powerUpPos.y, size*2, size*2);
  }
  
//Check if powerup collides with a player.
  boolean checkCollision() {
    for(int i = players.size() - 1; i > -1; i--) {
      Player _player = players.get(i);
      if(!_player.isDead) {
        if((powerUpPos.y > _player.y - (_player.pHeight/3)*2 && powerUpPos.y < _player.y + _player.pHeight)) {
          if((powerUpPos.x > _player.x && powerUpPos.x < _player.x + _player.pWidth)) {
            if(type > 0) {
              setWeaponTimers(_player, type);
              audioHandler.playSFX(4);
            }
            else {
              _player.hasShield = true;
              audioHandler.playSFX(5);
            }
            return true;
          }
        }
      }
    }
    return false;
  }
  
//Set the stats of the current weapon type.
  void setWeaponTimers(Player _player, int _weaponType) {
    _player.weaponType = _weaponType;
    _player.powerUpStartTime = millis();
    
    switch(_weaponType) {
      case(1):  //Piercing shot.
        _player.shotCooldown = 2000;
        _player.powerUpDuration = 5000;
      break;
      case(2):  //Rapid shot.
        _player.shotCooldown = 100;
        _player.powerUpDuration = 4000;
      break;
      case(3):  //Homeseking missile
        _player.shotCooldown = 1000;
        _player.powerUpDuration = 4000;
      break;
      case(4):  //Charge beam
        _player.shotCooldown = 500;
        _player.powerUpDuration = 4000;
      break;
    }
    
    _player.lastShot = millis();
  }
}
