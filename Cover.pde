class Cover {
  float groundHeight = height/30;
  float groundY;
  
  Cover() {
    groundY = height - groundHeight;
  }
  
  void display() {
    rectMode(CORNER);
    noStroke();
    fill(0, 255, 0);
    rect(0 , groundY, width, groundHeight);
  }
}
