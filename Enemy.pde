class Enemy {
  int x, y, dir, yStep, xStep;
  int eSize = 20;
  
  Enemy(int ex, int ey) {
    this.x = eSize/2 + eSize * ex;
    this.y = eSize/2 - eSize * ey;
    yStep = 0;
    xStep = 0;
  }
  
  void update() {
    if(x <= eSize) { dir = 1; }
    if(x >= width - eSize) { dir = -1; }
    
    x += eSize * dir;
    xStep++;
    if(xStep == width/eSize - 1) {
      y += eSize;
      xStep = 0;
    }
    
    noStroke();
    fill(156, 156, 156);
    ellipse(x, y, eSize, eSize);
  }
  
  void attack() {
    shoot(enemies.get(enemies.size()-1).x, enemies.get(enemies.size()-1).y, enemies.get(enemies.size()-1).eSize, 1, 100);
  }
}
