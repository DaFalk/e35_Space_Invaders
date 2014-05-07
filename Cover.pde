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
    for (int _y = 0; _y < groundHeight; _y++) {
      for (int _x = 0; _x < width; _x++) {
      }
    }
    rect(0 , groundY, width, groundHeight);
  }
}
