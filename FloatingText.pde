//
//
//

class FloatingText {
  PVector textPos;
  float startY;
  int score;
  String textToDisplay;
  int lastMove, startTime;
  int duration = 3000;
  float speed = dynamicValue(20);
  float size;
  
  FloatingText(PVector _textPos) {
    textAlign(CENTER, CENTER);
    textPos = _textPos;
    startY = textPos.y;
    lastMove = millis();
    startTime = millis();
    size = size;
  }
  
  void update() {
    textPos.y -= timeFix(speed, lastMove);
    size = menUI.labelHeight/2 + (startY - textPos.y)/2;
    lastMove = millis();
    displayText();
    if(millis() >= startTime + duration) {
      menUI.floatingTexts.remove(this);
    }
  }
  
  void displayText() {
    textSize(size);
    fill(255, 255, 255, 255 - (startY - textPos.y)*8);
    if(score > 0) {
      textToDisplay = "+"+score;
      fill(0, 255, 0, 255 - (startY - textPos.y)*8);
    }
    text(textToDisplay, textPos.x, textPos.y);
  }
}
