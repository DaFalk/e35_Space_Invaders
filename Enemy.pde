class Enemy {
  int eSize;
  float x, y;
  int score;
  int lastShot;
  int shotCooldown = 4000;
  int weaponType = 0;
  int moveInterval = 100; 
  int lastMove;

  Enemy(float _x, float _y, int _eSize, int _score) {
    this.x = _x;
    this.y = _y;
    this.eSize = _eSize;
    this.score = _score;
  }

  void display() {
    noStroke();
    fill(156, 156, 156);
    ellipse(x , y, eSize, eSize);
  }

  void shoot() {
    if(millis() >= lastShot + shotCooldown) {
      int _i = floor(random(0, enemies.size()));
      Enemy _enemy = enemies.get(_i);
      Shot s = new Shot(_enemy.x, _enemy.y + _enemy.eSize, weaponType, 10);
      shots.add(s);
      lastShot = millis();
      shotCooldown = ceil(random(3, 6))*1000;
    }
  }
  
  void damageEnemy() {
    spawner.spawnPowerUp(x, y, eSize);
    if(enemies.size() > 1) {
      enemies.remove(this);
      menUI.scoreTexts.add(new ScoreText(x, y, score));
    }
    else {
      menUI.scoreTexts.add(new ScoreText(enemies.get(0).x, enemies.get(0).y, enemies.get(0).score));
      spawner.respawnEnemies();
    }
  }
}

