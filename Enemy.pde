class Enemy {

  //size of enemies
  int eSize = 20;

  //  int enemyWidth = eSize;
  //  int enemyHeight = eSize;

  //  //spacing between enemies
  //  int enemyHorisontal =enemyWidth + 10;
  //  int enemyVertical=enemyHeight + 10;

  //movement and positioning of enemies 
  float x, y;

  int enemyRows = 9;
  int enemyCols = 5;

  float stepX = eSize*1.5;
  float stepY = eSize*1.5;
  float dirX = 1;
  boolean moveDown;
  //  int lastMove;


  int totalEnemies = enemyRows*enemyCols;


  Enemy(float _x, float _y) {
    this.x = _x*stepX;
    this.y = _y*stepY;
  }

  void update() {
    x += (stepX*dirX); //*(millis()-lastMove)*0.003;
    //lastMove = millis();

    checkCollision();
  }

  boolean checkCollision() {
    if ((x+eSize/2 >= width -eSize && dirX > 0) || (x + eSize/2 <= eSize && dirX < 0)) { // weird stuff
      dirX *= -1;

      return true;
    }
    return false;
  }

  void display() {
    noStroke();
    fill(156, 156, 156);
    ellipse(x, y, eSize, eSize);

    println(enemies.get(enemyRows-1).x, enemies.get(enemyRows-1).y, enemies.get(0).x, enemies.get(0).y);
  }


  void attack() {
    shoot(enemies.get(enemies.size()-1).x, enemies.get(enemies.size()-1).y, enemies.get(enemies.size()-1).eSize, 1, 100);
  }
}

