//
// 
// Spreadsheet references: https://github.com/joshsager/Fancy-Pants-Conference-Info-Wall/blob/master/RandomKittenSpreadsheet/SimpleSpreadsheetManager.pde
//                       : http://makezine.com/2010/12/10/save-sensor-data-to-google-spreadsh/
// Insertion sort reference: http://www.journaldev.com/585/insertion-sort-in-java-algorithm-and-code-with-example

class Highscores extends MenUI {
  SpreadsheetService service;
  WorksheetEntry wsEntry;
  WorksheetFeed wsFeed;
  ListFeed listFeed;
  List listEntries;
  
  String allowedKeys = "abcdefghijklmnopqrstuvwxyzæøåABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ123456789._-?&";
  String[] theNames = new String[11];
  String[] theScores = new String[11];
  String acc = "MPGD.Space.Invaders";
  String pwd = "exercise35";
  String spreadsheet_name = "Space Invaders Highscores";
  int spreadsheet_index = 0;
  boolean doRowUpdate = false;
  
  String myName;
  String myScore;
  int myPlace;
  boolean showIndicator = true;
  int lastTick;
  int numChars = 0;
  
  Highscores() {
    listFeed = new ListFeed();
    CellFeed cf = new CellFeed();
    wsFeed = new WorksheetFeed();
    service = new SpreadsheetService("test");
  }
  
  //Returns the content of a cell in the highscores spreadsheet.
  String getCellContent(int _col, int _row) {
    ListEntry listEntry = (ListEntry)listEntries.get(_row);    
    Set<String> tags = listEntry.getCustomElements().getTags();
    String[] tagArray = new String[tags.size()];
    tagArray = tags.toArray(tagArray);
    
    return listEntry.getCustomElements().getValue(tagArray[_col]);
  }
  
  //Sets the content of a cell in the highscores spreadsheet.
  void setCellContent(String _tag, int _row, String _content) {
    ListEntry listEntry = (ListEntry)listEntries.get(_row);
    listEntry.getCustomElements().setValueLocal(_tag, _content);
    if(doRowUpdate == true) {
      try { ListEntry updatedRow = listEntry.update(); }
      catch (Exception e){ println(e.toString()); }
    }
    doRowUpdate = !doRowUpdate;
  }
  
  void updateHighscores() {
    //Get spreadsheets feed
    try {
      //Attempt to sign-in to Google.
      service.setUserCredentials(acc, pwd);
      URL feedURL = new URL("http://spreadsheets.google.com/feeds/spreadsheets/private/full/");
      SpreadsheetFeed feed = service.getFeed(feedURL, SpreadsheetFeed.class);
      for(SpreadsheetEntry entry: feed.getEntries()) {
        if(entry.getTitle().getPlainText().equals(spreadsheet_name)) {
          //Break out of the loop if right sheet was found.
          break;
        }
        //Increase index to check if the next sheet is the right one.
        spreadsheet_index += 1;
      }
      SpreadsheetEntry se = feed.getEntries().get(spreadsheet_index);
      wsEntry = se.getWorksheets().get(players.size()-1);
      println("Found worksheet ''" + se.getTitle().getPlainText() + "'' on Google Drive");
    }
    catch(Exception e) { println("Could not find a worksheet!"); }
    
    //Get list feed URL.
    List worksheets = wsFeed.getEntries();
    try {
      URL listFeedURL = new URL("http://spreadsheets.google.com/feeds/list/1oZZcCmDsuZIvEOVTPXqtqi3vzNukf2B-0aItSb-tXtU/od6/private/full");
      URL listFeedUrl = wsEntry.getListFeedUrl();
      ListFeed lf2 = new ListFeed();
      listFeed = service.getFeed(listFeedUrl, lf2.getClass());
      println("Found list feed " + wsEntry.getTitle().getPlainText());
    }
    catch(Exception e) { println(e.toString()); }
    
    listEntries = listFeed.getEntries();
    
    // Get content of each name and score cell in the spreadsheet
    // -1 due to theNames and theScores also hold the game's final score which the spreadsheet don't.
    for(int i = 0; i < theNames.length-1; i++) {
      theNames[i] = getCellContent(0, i);
      theScores[i] = getCellContent(1, i);
    }
    theNames[theNames.length-1] = "";
    theScores[theScores.length-1] = nf(calcTotalScore(), 0);
    myName = theNames[theNames.length-1];
    myScore = theScores[theScores.length-1];
    
    insertionSortArrays();
    
    loading = false;
    showHighscores = true;
  }
  
  //Convert theScores string array to int array and sorts both theScores and theNames, the latter based on theScores.
  void insertionSortArrays() {
    for(int i = 1; i < theScores.length; i++) {
      int intToSort = Integer.parseInt(theScores[i]);
      String _name = theNames[i];
      int j = i;
      //Checks if the int on the index before i smaller and swaps if they are.
      while(j > 0 && Integer.parseInt(theScores[j-1]) < intToSort) {
        theScores[j] = theScores[j-1];
        theNames[j] = theNames[j-1];
        j--;
      }
      theScores[j] = nf(intToSort, 0);
      theNames[j] = _name;
      if(myName == theNames[j]) { myPlace = j; }
    }
  }
  
  void display() {
    //Draw highscore screen.
    fill(0, 200);
    rectMode(CENTER);
    rect(width/2, height/2, width, height);  //Draw transparent highscores background.
    drawBackground(height*0.65, height*0.625);  //Draw bottom glow.
    fill(0, 255);
    stroke(255);
    strokeWeight(labelHeight/10);
    rect(width/2, height/2, width/2, height/1.8);  //Draw bounding rect.
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(labelHeight);
    text(wsEntry.getTitle().getPlainText(), width/2 + labelHeight/8, labelHeight*4.6);
    fill(0, 255, 0);
    textSize(labelHeight*2);
    text("HighScores", width/2 + labelHeight/8, labelHeight*5.6);
    displayBtns(height/4 + labelHeight*3, 1);  //Draw 1 button.
    
    float _x = 0;
    for(int i = 0; i < theNames.length-1; i++) {
      String _numPlace = nf(i+1, 0) + ". ";
      String _name = theNames[i];
      String _score = " : " + theScores[i];
      float _y = height/2 - height/4 + labelHeight*0.75 + (labelHeight*1.5)*i;
      
      if(i <= 2) {
        textSize(labelHeight*(1.45 - 0.15*i));
        _x = width/2 + labelHeight*1.5 - textWidth(_numPlace) - textWidth(_name)/2;
        if(i == 0) { fill(255, 215, 0); }
        if(i == 1) { fill(150, 90, 56); }
        if(i == 2) { fill(126, 126, 126); }
      }
      else {
        textSize(labelHeight);
        _x = width/2 - width/6.5 + labelHeight*1.5 + textWidth("10. ");
        fill(255);
      }
      
      if(myName == theNames[i]) {
        stroke(255);
        if(millis() - lastTick >= 500) {
          showIndicator = !showIndicator;
          lastTick = millis();
        }
        if(showIndicator) {
          line(_x + labelHeight/20, _y + labelHeight/1.5, _x + (labelHeight*0.75)*(1+numChars) + labelHeight/20, _y + labelHeight/1.5);
        }
      }
      
      textAlign(RIGHT, CENTER);
      text(_numPlace, _x, _y);
      textAlign(LEFT, CENTER);
      text(_name, _x, _y);
      text(_score, _x + textWidth(_name), _y);
    }
  }
  
  void updateName() {
    for(int i = 0; i < theNames.length-1; i++) {
      if(myName == theNames[i]) {
        if(key == ENTER || mouseButton == LEFT) {
          if(myName == "") { myName = "???"; }
          theNames[i] = myName;
          displayLoadingScreen(upload);
          saveHighscore();
        }
        if(numChars <= 2 && key != ENTER && key != BACKSPACE) {
          for(int k = 0; k < allowedKeys.length(); k++) {
            if(key == allowedKeys.charAt(k)) {
              myName = myName + key;
              numChars++;
            }
          }
        }
        if(key == BACKSPACE && myName.length() > 0) {
          myName = myName.substring(0, myName.length()-1);
          numChars--;
        }
        theNames[i] = myName;
      }
    }
  }
  
  void saveHighscore() {
    // Set the new content of each name and score cell in the spreadsheet
    for(int i = 0; i < theNames.length-1; i++) {
      setCellContent("theScores", i, theScores[i]);
      setCellContent("theNames", i, theNames[i]);
    }
    resetGame();
  }
}
