class Shot {
  float x, y;
  int dir, lastMove, owner;
  int shotSize = 5;
  int speed = 150;
  
  Shot(float _x, float _y, int direction, int player) {
    this.x = _x;
    this.y = _y;
    this.dir = direction;
    this.lastMove = millis();
    this.owner = player;
    audioHandler.playSFX(1);
  }
  
  void update() {
    y += (speed*dir)*((millis()-lastMove)*0.001);
    lastMove = millis();
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
    if((y < 0 && dir < 0) || (y > height + shotSize && dir > 0)) {
      return true;
    }
    if(dir < 0) {
      for(int i = enemies.size() - 1; i > -1; i--) { //Correct when enemy y problem is solved.
        if(y < enemies.get(i).y + enemies.get(i).eSize/2 && y > enemies.get(i).y - enemies.get(i).eSize/2) {
          if(x < enemies.get(i).x + enemies.get(i).eSize/2 && x > enemies.get(i).x - enemies.get(i).eSize/2) {
            players.get(owner).adjustScore();
            enemies.remove(i);
            return true;
          }
        }
      }
      return false;
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
    return false;
  }
}
