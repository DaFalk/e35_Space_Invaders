//  This class draws a text at a requested position and moves it upwards while enlarging the text and decreasing alpha.
//
//

class FloatingText {
  PVector textPos;
  float startY;
  int score;  //If the text contains numbers.
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
    //Move up.
    textPos.y -= timeFix(speed, lastMove);
    //Scale according to height difference between current position and starting position.
    size = dynamicValue(10) + (startY - textPos.y)/2;
    lastMove = millis();
    displayText();
    //Remove after time period.
    if(millis() >= startTime + duration) {
      menUI.floatingTexts.remove(this);
    }
  }
  
  void displayText() {
    textSize(size);
    fill(255, 255, 255, 255 - (startY - textPos.y)*8);
    //Check if text contains numbers.
    if(score > 0) {
      //If so add a + sign in front.
      textToDisplay = "+"+score;
      fill(0, 255, 0, 255 - (startY - textPos.y)*8);
    }
    text(textToDisplay, textPos.x, textPos.y);
  }
}
