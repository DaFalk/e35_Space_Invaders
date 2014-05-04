class Player {
  String lifesLabel;
  float x, y;
  int lastMove, lastShot, shotCooldown, left, right, lifes, pHeight;
  int pWidth = 40;
  int speed = 150;
  int score = 0;
  boolean attack;
  int weaponType, weaponDamage;
  int powerUpStartTime, powerUpDuration;
  boolean isDead = false;
  
  Player(float xPos) {
    this.lifesLabel = "LIFES";
    this.x = xPos - pWidth/2;
    this.lifes = 3;
    this.attack = false;
    this.shotCooldown = shotCooldown;
    this.powerUpDuration = powerUpDuration;
    setWeaponStats(0);
    y = height - pWidth;
    pHeight = pWidth/4;
  }
  
  void update() {
    if(!isDead) {
      if(!gamePaused) {
        x += (right - left) * (speed*(millis()-lastMove)*0.001);
        lastMove = millis();
        checkCollision();
        if(attack) { shoot(); }
        handlePowerUp();
      }
      drawPlayer(x, y);
    }
  }
  
  void drawPlayer(float _x, float _y) {
    rectMode(CORNER);
    noStroke();
    fill(0, 255, 0);
    //Body
    rect(_x, _y, pWidth, pHeight);
    rect(_x + (pWidth - pWidth*0.85)/2, _y - pHeight/3, pWidth*0.85, pHeight/3);
    //Canon
    rect(_x + pWidth/2.5, _y - pWidth/5, pWidth/5, pWidth/5);
    rect(_x + pWidth*(0.5 - (0.075/2)), _y - pWidth/3.5, pWidth*0.075, pWidth/3.5);
  }
  
  void checkCollision() {
    if(x <= 0) { x = 0; }
    if(x >= width - pWidth) { x = width - pWidth; }
  }
  
  void shoot() {
    if(millis() - lastShot >= shotCooldown) {
      Shot s = new Shot(new PVector(x + pWidth/2, y - pHeight), weaponType, players.indexOf(this), weaponDamage);
      shots.add(s);
      lastShot = millis();
    }
  }
  
  void adjustLifes() {
    lifes--;
    if(lifes > 0) { spawner.respawnPlayer(this); }
    else {
      isDead = true;
      lifesLabel = "DEAD";
      menUI.calcAllLifes();
    }
  }
  
  void handlePowerUp() {
    if(weaponType != 0) {
      if(millis() >= powerUpStartTime + powerUpDuration) {
        setWeaponStats(0);
      }
    }
  }
  
  void setWeaponStats(int _weaponType) {
    weaponType = _weaponType;
    powerUpStartTime = millis();
    switch(weaponType) {
     case(0):
      weaponDamage = 6;
      shotCooldown = 1000;
      break;
     case(1):
      shotCooldown = 2000;
      weaponDamage = 6;
      powerUpDuration = 5000;
      break;
     case(2):
      shotCooldown = 100;
      weaponDamage = 2;
      powerUpDuration = 3000;
      break;
     case(3):
      shotCooldown = 2000;
      weaponDamage = 6;
      powerUpDuration = 10000;
      break;
     case(4):
      shotCooldown = 200;
      weaponDamage = 1;
      powerUpDuration = 10000;
      break;
    }
    lastShot = shotCooldown;
  }
  
  void keyDown() {
    if(key == 'a' || key == 'A') { left = 1; }
    if(key == 'd' || key == 'D') { right = 1; }
    if(key == ' ') { attack = true; }
    if(keyCode == LEFT) { left = 1; }
    if(keyCode == RIGHT) { right = 1; }
    if(keyCode == UP) { attack = true; }
    
    //testing purpose
    switch(key) {
      case('0'):
       weaponType = 0;
       setWeaponStats(weaponType);
       break;
      case('1'):
       weaponType = 1;
       setWeaponStats(weaponType);
       break;
      case('2'):
       weaponType = 2;
       setWeaponStats(weaponType);
       break;
      case('3'):
       weaponType = 3;
       setWeaponStats(weaponType);
       break;
      case('4'):
       weaponType = 4;
       setWeaponStats(weaponType);
       break;
      case('e'):
       adjustLifes();
       break;
    }
  }
  
  void keyUp() {
    if(key == 'a' || key == 'A') { left = 0; }
    if(key == 'd' || key == 'D') { right = 0; }
    if(key == ' ') { attack = false; }
    if(keyCode == LEFT) { left = 0; }
    if(keyCode == RIGHT) { right = 0; }
    if(keyCode == UP) { attack = false; }
  }
}
