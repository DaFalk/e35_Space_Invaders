class Shot {
  float x, y;
  int dir;
  int shotSize = 5;
  int speed = 5;
  
  Shot(float x, float y, int direction) {
    this.x = x;
    this.y = y;
    this.dir = direction;
  }
  
  void update() {
    y += (speed * dir);
    
    checkCollision();
    display();
  }
  
  void display() {
    stroke(0, 255, 0);
    strokeWeight(2);
    line(x, y, x, y + (shotSize*dir));
  }
  
  void checkCollision() {
    if(dir < 0) {
      for(int i = enemies.size() - 1; i > -1; i--) {
        if(y < enemies.get(i).y + enemies.get(i).eSize/2 && y > enemies.get(i).y - enemies.get(i).eSize/2) {
          if(x < enemies.get(i).x + enemies.get(i).eSize/2 && x > enemies.get(i).x - enemies.get(i).eSize/2) {
            enemies.remove(i);
            shots.remove(this);
          }
        }
      }
      if(y < 0) {
        shots.remove(this);
      }
    }
    else {
      if((y > player1.y - player1.pWidth * 1.5 && y < player1.y)) {
        if((x > player1.x - player1.pWidth/2 && x < player1.x + player1.pWidth/2) || (x > player2.x - player2.pWidth/2 && x < player2.x + player2.pWidth/2)) {
          shots.remove(this);
        }
      }
      if(y > height + shotSize) {
        shots.remove(this);
      }
    }
  }
}
