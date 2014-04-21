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
    
    if(checkCollision()) {
      shots.remove(this);
    }
    display();
  }
  
  void display() {
    stroke(255, 255, 255);
    strokeWeight(2);
    line(x, y, x, y + (shotSize*dir));
  }
  
  boolean checkCollision() {
    if(dir < 0) {
      for(int i = enemies.size() - 1; i > -1; i--) {
        if(y < enemies.get(i).y + enemies.get(i).eSize/2 && y > enemies.get(i).y - enemies.get(i).eSize/2) {
          if(x < enemies.get(i).x + enemies.get(i).eSize/2 && x > enemies.get(i).x - enemies.get(i).eSize/2) {
            enemies.remove(i);
            return true;
          }
        }
      }
    }
    else {
      for(int i = players.size() - 1; i > -1; i--) {
        if((y > players.get(i).y - players.get(i).pWidth * 1.5 && y < players.get(i).y)) {
          if((x > players.get(i).x - players.get(i).pWidth/2 && x < players.get(i).x + players.get(i).pWidth/2)) {
            return true;
          }
        }
      }
    }
    
    if(y < 0 || y > height + shotSize) {
      return true;
    }
    
    return false;
  }
}
