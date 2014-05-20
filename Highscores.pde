/*
 MPGD: Exercise 35: Space Invaders
 Jimmie Gustafsson (jgus) & Troels Falkenberg (tfal)
 
This class manages the highscorelist.

Previous data is pulled from a Google spreadsheet to temporary local arrays, sorted, displayed
and in the end uploaded back to the correct worksheet in the spreadsheet (multi- or singleplayer).

Spreadsheet references: 
https://github.com/joshsager/Fancy-Pants-Conference-Info-Wall/blob/master/RandomKittenSpreadsheet/SimpleSpreadsheetManager.pde
http://makezine.com/2010/12/10/save-sensor-data-to-google-spreadsh/

Insertion sort reference: 
http://www.journaldev.com/585/insertion-sort-in-java-algorithm-and-code-with-example
*/

class Highscores extends MenUI {
  SpreadsheetService service;
  WorksheetEntry wsEntry;
  WorksheetFeed wsFeed;
  ListFeed listFeed;
  List listEntries;
  
  String allowedKeys = "abcdefghijklmnopqrstuvwxyzæøåABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ123456789._-?&";  //Contains all keys allowed to use when typing name in highscorelist.
  String[] theNames = new String[11];
  String[] theScores = new String[11];
  String acc = "MPGD.Space.Invaders";
  String pwd = "exercise35";
  String spreadsheet_name = "Space Invaders Highscores";  //Exact name of spreadsheet (case-sensitive).
  int spreadsheet_index = 0;
  boolean doRowUpdate = false;
  
  String myName;
  String myScore;
  int myPlace;
  boolean showIndicator = true;
  int lastTick;
  int numChars = 0;
  
  boolean uploading = false;
  
  Highscores() {
    listFeed = new ListFeed();
    CellFeed cf = new CellFeed();
    wsFeed = new WorksheetFeed();
    service = new SpreadsheetService("test");
  }
  
  //Returns the content of a cell in the highscores spreadsheet.
  String getCellContent(int _col, int _row) {
    ListEntry listEntry = (ListEntry)listEntries.get(_row);  //Store all entries of a single row.
    Set<String> tags = listEntry.getCustomElements().getTags();  //Get the tags of the cells in the row (theNames and theScores).
    String[] tagArray = new String[tags.size()];
    tagArray = tags.toArray(tagArray);  //Store tags in array.
    
    return listEntry.getCustomElements().getValue(tagArray[_col]);  //Return the content of cell matching the row and tag/column.
  }
  
  //Sets the content of a cell in the highscores spreadsheet.
  void setCellContent(String _tag, int _row, String _content) {
    ListEntry listEntry = (ListEntry)listEntries.get(_row);  //Store row.
    listEntry.getCustomElements().setValueLocal(_tag, _content);  //Set the content of the cell in the row matching the tag.
    if(doRowUpdate == true) {  //To avoid updating row multiple times the doRowUpdate boolean is used.
      try { ListEntry updatedRow = listEntry.update(); }  //Try to update row.
      catch (Exception e){ println("Failed to update row!"); }
    }
    doRowUpdate = !doRowUpdate;
  }
  
  void updateHighscores() {
    //Get spreadsheets feed
    try {
      service.setUserCredentials(acc, pwd);  //Attempt to sign-in to Google.
      URL feedURL = new URL("http://spreadsheets.google.com/feeds/spreadsheets/private/full/");  //Link to spreadsheets feed.
      SpreadsheetFeed feed = service.getFeed(feedURL, SpreadsheetFeed.class);  //Store feed of spreadsheets.
      
      for(SpreadsheetEntry entry: feed.getEntries()) {  //Check all spreadsheets in feed.
        if(entry.getTitle().getPlainText().equals(spreadsheet_name)) {  //Check if the current spreasheet from the feed matches the name of the right spreadsheet.
          break;  //Break out of the for loop if right spreadsheet was found.
        }
        spreadsheet_index += 1;  //Increase index to check the next sheet.
      }
      
      SpreadsheetEntry se = feed.getEntries().get(spreadsheet_index);  //Store the spreadsheet.
      wsEntry = se.getWorksheets().get(players.size()-1);  //Get the correct worksheet (single- or multiplayer sheet).
      println("Found worksheet ''" + se.getTitle().getPlainText() + "'' on Google Drive");
    }
    catch(Exception e) { println("Could not find a worksheet!"); }
    
    //Get list feed URL.
    List worksheets = wsFeed.getEntries();  //Store all worksheets in list.
    try {
      URL listFeedUrl = wsEntry.getListFeedUrl();  //Get feed URL from current worksheet.
      ListFeed lf2 = new ListFeed();  //New ListFeed to get access to it's class.
      listFeed = service.getFeed(listFeedUrl, lf2.getClass());  //Store worksheet feed.
      println("Found list feed " + wsEntry.getTitle().getPlainText());
    }
    catch(Exception e) { println(e.toString()); }
    
    listEntries = listFeed.getEntries();
    
    //Store data from highscorelist in the associated arrays.
    //The last spot in the arrays are for the local player name and score.
    for(int i = 0; i < theNames.length-1; i++) {
      theNames[i] = getCellContent(0, i);
      theScores[i] = getCellContent(1, i);
    }
    
    //Initially set the player name to empty and calculate score.
    theNames[theNames.length-1] = "";
    theScores[theScores.length-1] = nf(calcTotalScore(), 0);
    //Match myName and myScore with the arrays.
    myName = theNames[theNames.length-1];
    myScore = theScores[theScores.length-1];
    
    insertionSortArrays();  //Sort the arrays.
    
    showHighscores = true;
  }
  
  //Convert theScores string to int and sorts both theScores and theNames, the latter based on theScores.
  void insertionSortArrays() {
    for(int i = 1; i < theScores.length; i++) {  //Start at 1 since it checks backwards.
      //Store the data that is potentially moved so it is not overwritten.
      int intToSort = Integer.parseInt(theScores[i]);
      String _name = theNames[i];
      
      //Checks if the previous index is smaller than "i".
      int j = i;
      while(j > 0 && Integer.parseInt(theScores[j-1]) < intToSort) {
        //Move previous value to this index.
        theScores[j] = theScores[j-1];
        theNames[j] = theNames[j-1];
        j--;  //Reduce j to get previous index.
      }
      
      //Move this index's original value to previous index.
      theScores[j] = nf(intToSort, 0);
      theNames[j] = _name;
      
      //Store player's placement on highscorelist.
      if(myName == theNames[j]) { myPlace = j; }
    }
  }
  
  void display() {
    //Draw highscore screen.
    fill(0, 200);
    rect(width/2, height/2, width, height);  //Draw black transparent overlay background.
    drawBackground(height*0.65, height*0.625);  //Draw bottom glow.
    fill(0, 255);
    stroke(255);
    strokeWeight(labelHeight/10);
    rect(width/2, height/2, width/2, height/1.8);  //Draw bounding rect.
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(labelHeight);
    text(wsEntry.getTitle().getPlainText(), width/2 + labelHeight/8, labelHeight*4.6);  //Display the title of the spreadsheet.
    fill(0, 255, 0);
    textSize(labelHeight*2);
    text("HighScores", width/2 + labelHeight/8, labelHeight*5.6);
    displayBtns(height/4 + labelHeight*3, 1);  //Draw 1 button.
    
    //Display each highscore.
    float _x = 0;
    for(int i = 0; i < theNames.length-1; i++) {
      String _numPlace = nf(i+1, 0) + ". ";
      String _name = theNames[i];
      String _score = " : " + theScores[i];
      float _y = height/2 - height/4 + labelHeight*0.75 + (labelHeight*1.5)*i;
      
      if(_name == null) { _name = "???"; }
      
      if(i <= 2) {
        //Display top 3 highscores with individual color and size
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
      
      //Display blinking indicator if one of the names on the highscore list match the temporary empty myName.
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
      
      //Display place, name and score
      textAlign(RIGHT, CENTER);
      text(_numPlace, _x, _y);
      textAlign(LEFT, CENTER);
      text(_name, _x, _y);
      text(_score, _x + textWidth(_name), _y);
    }
    
    //Save the name and highscore if uploading is true.
    if(uploading) {
      displayLoadingScreen(upload);
      saveHighscore();
      uploading = false;
    }
  }
  
  //On every key input in highscore screen updates the entered highscore name.
  void updateName() {
    if(showHighscores) {
      for(int i = 0; i < theNames.length-1; i++) {
        if(myName == theNames[i]) {
          //Only enter text if the maximum allowed number of characters hasn't been exeeded.
          if(numChars <= 2 && key != ENTER && key != BACKSPACE) {
            //Check key input agains each character in the allowedKeys.
            for(int k = 0; k < allowedKeys.length(); k++) {
              if(key == allowedKeys.charAt(k)) {
                myName = myName + key;  //if key was allowed then add that character to myName.
                numChars++;
              }
            }
          }
          
          //Delete character.
          if(key == BACKSPACE && myName.length() > 0) {
            //Subtract the last characters of myName if BACKSPACE is pressed.
            myName = myName.substring(0, myName.length()-1);
            numChars--;
          }
          
          //Delete name.
          if(key == DELETE) {
            myName = myName.substring(0, myName.length()-numChars);
            numChars = 0;
          }
          
          theNames[i] = myName;  //Update name.
          
          //Pressing ENTER or the Quit button saves the highscorelist
          if(key == ENTER || mouseClicked) {
            if(myName == "") { myName = "???"; }  //If no name is written then "???" is set as the name.
            theNames[i] = myName;
            displayLoadingScreen(upload);
            uploading = true;
          }
        }
      }
    }
  }
  
  void saveHighscore() {
    // Writes the sorted local arrays of names and scores to the Google spreadsheet.
    for(int i = 0; i < theNames.length-1; i++) {
      setCellContent("theScores", i, theScores[i]);
      setCellContent("theNames", i, theNames[i]);
    }
    uploading = false;
    resetGame();
  }
}
