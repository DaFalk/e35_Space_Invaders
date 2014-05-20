/*
This class draws a powerup icon with ellipses colored according to type and moves it downwards and checks player collision.
 */

class PowerUp {
  PVector powerUpPos;
  String name;  //Name of powerup for player collision floating text.
  float size;
  float speed = dynamicValue(50);
  int lastMove, type;

  PowerUp(PVector _pos, float _size) {
    powerUpPos = _pos;
    size = _size*0.75;
    lastMove = millis();
    type = ceil(random(-1, 4));
    namePowerUp();
  }

  void update() {
    if (!gamePaused) {
      powerUpPos.y += timeFix(speed, lastMove);
      lastMove = millis();
      if (checkCollision()) { 
        powerUps.remove(this);
      }
    }
    drawPowerUp();
  }

  //Draw powerup icon and color according to type.
  void drawPowerUp() {
    noStroke();
    fill(0, 255, 0);
    triangle(powerUpPos.x - size/2, powerUpPos.y - size/2, powerUpPos.x + size/2, powerUpPos.y - size/2, powerUpPos.x, powerUpPos.y + size/2);
    stroke(0, 255, 0);
    strokeWeight(dynamicValue(2));
    noFill();
    ellipse(powerUpPos.x, powerUpPos.y, size, size);
    strokeWeight(dynamicValue(3));
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

  //Check if powerup collides with an alive player.
  boolean checkCollision() {
    for (int i = players.size() - 1; i > -1; i--) {
      Player _player = players.get(i);
      if (!_player.isDead && collisionCheck(powerUpPos, size, size, new PVector(_player.x, _player.y), _player.pWidth/2, _player.pHeight)) {
        //If powerup is not a shield.
        if (type > 0) {
          //Set players weapon type.
          setWeaponTimers(_player, type);
          audioHandler.playSFX(4);
        }
        else {
          //Give player a shield.
          _player.hasShield = true;
          audioHandler.playSFX(5);
        }
        menUI.addFloatingText(null, powerUpPos, name);  //Display floating text with name of powerup.
        return true;
      }
    }
    return false;
  }

  //Set powerup name based on type.
  void namePowerUp() {
    switch(type) {
      case(0):
      name = "Shield";
      break;
      case(1):
      name = "Piercer";
      break;
      case(2):
      name = "Rapid fire";
      break;
      case(3):
      name = "Seeker";
      break;
      case(4):
      name = "Arc beam";
      break;
    }
  }

  //Set the player's weapon type, shot duration and powerup duration according to this powerup type.
  void setWeaponTimers(Player _player, int _weaponType) {
    _player.weaponType = _weaponType;
    _player.powerUpStartTime = millis();

    switch(_weaponType) {
      case(1):
      _player.shotCooldown = 2000;
      _player.powerUpDuration = 5000;
      break;
      case(2):
      _player.shotCooldown = 100;
      _player.powerUpDuration = 4000;
      break;
      case(3):
      _player.shotCooldown = 1000;
      _player.powerUpDuration = 4000;
      break;
      case(4):
      _player.shotCooldown = 500;
      _player.powerUpDuration = 4000;
      break;
    }

    _player.lastShot = millis();
  }
}

