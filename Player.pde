// This class draws a player and manages the player's movement, death, powerup effects and lifes.
//
//

class Player {
  String lifesLabel = "LIFES";
  float x, y;
  int lastMove, lastShot, shotCooldown, left, right;
  int weaponType, powerUpStartTime, powerUpDuration;
  int lifes = 3;
  int score = 0;
  float pWidth = dynamicValue(40);
  float pHeight = dynamicValue(10);
  float speed = dynamicValue(150);
  boolean attack = false;
  boolean isDead = false;
  boolean hasShield = false;
  
  Player(float xPos) {
    x = xPos;
    y = height - pWidth;
    weaponType = 0;  //Set default weapon type.
    shotCooldown = 1000;  //Set default shot cooldown.
  }
  
  void update() {
    //Draw player if alive and manage movement, collision, shooting and powerup effects if game is also unpaused.
    if(!isDead) {
      if(!gamePaused) {
        x += (right - left) * timeFix(speed, lastMove);
        lastMove = millis();
        checkCollision();
        if(attack) { shoot(); }
        handlePowerUp();
      }
      drawPlayer(x, y, 1, true);
    }
  }
  
  void drawPlayer(float _x, float _y, float _scale, boolean _active) {
    noStroke();
    float _pWidth = pWidth*_scale;
    float _pHeight = pHeight*_scale;
    fill(0, 255, 0);
    //Body
    rect(_x, _y + _pHeight/2, _pWidth, _pHeight);
    rect(_x, _y - _pHeight/6, _pWidth*0.85, _pHeight/3);
    //Canon
    rect(_x, _y - _pWidth/5 + _pHeight/2, _pWidth/5, _pWidth/5);
    rect(_x, _y - _pWidth/3.5 + _pHeight/2, _pWidth*0.075, _pWidth/3.5);
    
   
    //Draw shield if player is active(ie. not UI) and shield powerup has been optained.
    if(_active && hasShield) {
      fill(200, 200, 255,100);
      ellipse(_x, _y, _pWidth*1.4, _pWidth*0.85);
    }
  }
  
//Keep player within bounds.
  void checkCollision() {
    if(x <= 0) { x = 0; }
    if(x >= width - pWidth) { x = width - pWidth; }
  }
  
//Trigger a shot of current weapon type.
  void shoot() {
    if(millis() - lastShot >= shotCooldown) {
      //Initialize a shot with position, type and owner index.
      Shot s = new Shot(new PVector(x, y - pHeight), weaponType, players.indexOf(this));
      shots.add(s);
      lastShot = millis();
    }
  }
  
//Subtract life, reset weapon type and check if player has lifes left or is dead.
  void adjustLifes() {
    lifes--;
    weaponType = 0;
    shotCooldown = 1000;
    //If player has lifes left then respawn player.
    if(lifes > 0) { spawner.respawnPlayer(this); }
    else {
      //Check the total amount of player lifes in case of multiple players.
      menUI.calcAllLifes();
      isDead = true;
      lifesLabel = "DEAD";  //Change lifes label.
    }
  }
  
//Manage powerup duration and ajdust weapon type.
  void handlePowerUp() {
    //If the weapon type isn't default then reset to default once powerup runs out.
    if(weaponType != 0) {
      if(millis() >= powerUpStartTime + powerUpDuration) {
        weaponType = 0;
        shotCooldown = 1000;
      }
    }
  }
  
  //Set direction or attack on key input.
  void keyDown() {
    if(key == 'a' || key == 'A') { left = 1; }
    if(key == 'd' || key == 'D') { right = 1; }
    if(key == ' ') { attack = true; }
    if(keyCode == LEFT) { left = 1; }
    if(keyCode == RIGHT) { right = 1; }
    if(keyCode == UP) { attack = true; }
    
    //for testing purpose only :)
    switch(key) {
    case('0'):
      hasShield = true;
    break;
    case('1'):
      weaponType = 1;
      shotCooldown = 2000;
      powerUpDuration = 5000;
      powerUpStartTime = millis();
      lastShot = millis();
    break;
    case('2'):
      weaponType = 2;
      shotCooldown = 100;
      powerUpDuration = 4000;
      powerUpStartTime = millis();
      lastShot = millis();
    break;
    case('3'):
      weaponType = 3;
      shotCooldown = 1000;
      powerUpDuration = 4000;
      powerUpStartTime = millis();
      lastShot = millis();
    break;
    case('4'):
      weaponType = 4;
      shotCooldown = 500;
      powerUpDuration = 4000;
      powerUpStartTime = millis();
      lastShot = millis();
    break;
    case('e'):
      if(!isDead) { players.get(0).adjustLifes(); if(isMultiplayer) {players.get(1).adjustLifes();} }
    break;
    }
  }
  
  //Reset direction or attack when releasing key.
  void keyUp() {
    if(key == 'a' || key == 'A') { left = 0; }
    if(key == 'd' || key == 'D') { right = 0; }
    if(key == ' ') { attack = false; }
    if(keyCode == LEFT) { left = 0; }
    if(keyCode == RIGHT) { right = 0; }
    if(keyCode == UP) { attack = false; }
  }
}
