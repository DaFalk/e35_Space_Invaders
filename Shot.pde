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
    stroke(0, 255, 0);
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
      if((y > players.get(0).y - players.get(0).pWidth * 1.5 && y < players.get(0).y)) {
        if((x > players.get(0).x - players.get(0).pWidth/2 && x < players.get(0).x + players.get(0).pWidth/2) || (x > players.get(1).x - players.get(1).pWidth/2 && x < players.get(1).x + players.get(1).pWidth/2)) {
          return true;
        }
      }
    }
    
    if(y < 0 || y > height + shotSize) {
      return true;
    }
    
    return false;
  }
}
