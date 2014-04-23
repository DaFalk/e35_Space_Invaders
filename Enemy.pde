class Enemy {
  int eSize = 20;
  float x, y;

  int enemyRows = 9;
  int enemyCols = 5;

  float stepX = eSize*1.5;
  float stepY = eSize*1.5;
  float dirX = 1;
  float moveY;
  //  int lastMove;

  int totalEnemies = enemyRows*enemyCols;

  Enemy(float _x, float _y) {
    this.x = _x*stepX;
    this.y = _y*stepY;
  }

  void update() {
    //Move enemy
    x += (stepX*dirX);
    checkCollision();
    display();
  }

  boolean checkCollision() {
    if ((x+eSize/2 >= width -eSize && dirX > 0) || (x + eSize/2 <= eSize && dirX < 0)) { // weird stuff
      dirX *= -1;
      moveY += stepY;
      return true;
    }
    return false;
  }

  void display() {
    noStroke();
    fill(156, 156, 156);
    ellipse(x , y + moveY, eSize, eSize);
  }

  void attack() {
    shoot(enemies.get(enemies.size()-1).x, enemies.get(enemies.size()-1).y, enemies.get(enemies.size()-1).eSize, 1, 100);
  }
}

