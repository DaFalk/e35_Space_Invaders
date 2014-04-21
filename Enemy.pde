class Enemy {
  int x, y, dir, yStep, xStep, speed;
  int eSize = 20;
  int moveTime = 100;
  int startTime, curTime;
  
  Enemy(int ex, int ey) {
    this.x = eSize/2 + eSize * ex;
    this.y = eSize/2 - eSize * ey;
    yStep = 0;
    xStep = 0;
  }
  
  void update() {
    if(x <= eSize) { dir = 1; }
    if(x >= width - eSize) { dir = -1; }
    
    curTime = millis() - startTime;
    if(curTime >= moveTime) {
      x += eSize * dir;
      xStep++;
      if(xStep == width/eSize - 1) {
        y += eSize;
        xStep = 0;
      }
      startTime = millis();      
    }
    
    fill(156, 156, 156);
    ellipse(x, y, eSize, eSize);
  }
}
