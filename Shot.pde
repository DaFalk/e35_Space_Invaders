class Shot {
  float x, y;
  int dir;
  int shotSize = 5;
  int speed = 5;
  int owner;
  
  Shot(float x, float y, int direction, int player) {
    this.x = x;
    this.y = y;
    this.dir = direction;
    this.owner = player;
    audio[1].rewind();
    audio[1].play();
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
            players.get(owner).adjustScore();
            enemies.remove(i);
            return true;
          }
        }
      }
    }
    else {
      for(int i = players.size() - 1; i > -1; i--) {
        if(!players.get(i).isDead) {
          if((y > players.get(i).y - players.get(i).pHeight - players.get(i).pHeight/3 && y < players.get(i).y + players.get(i).pHeight)) {
            if((x > players.get(i).x && x < players.get(i).x + players.get(i).pWidth)) {
              players.get(i).adjustLifes();
              return true;
            }
          }
        }
      }
    }
    
    if((y < 0 && dir < 0) || (y > height + shotSize && dir > 0)) {
      return true;
    }
    
    return false;
  }
}
