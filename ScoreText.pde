class ScoreText {
  float x, y, startY;
  int score;
  int lastMove, startTime;
  int duration = 3000;
  int speed = 20;
  float size;
  
  ScoreText(float _x, float _y, int _score) {
    textAlign(CENTER, CENTER);
    this.x = _x;
    this.y = _y;
    this.startY = _y;
    this.score = _score;
    this.lastMove = millis();
    this.startTime = millis();
    this.size = size;
  }
  
  void update() {
    y -= speed*(millis()-lastMove)*0.001;
    size = menUI.labelHeight/2 + (startY - y)/2;
    lastMove = millis();
    displayText();
    if(millis() >= startTime + duration) {
      menUI.scoreTexts.remove(this);
    }
  }
  
  void displayText() {
    textSize(size);
    fill(0, 255, 0, 255 - (startY - y)*8);
    text("+"+score, x, y);
  }
}
