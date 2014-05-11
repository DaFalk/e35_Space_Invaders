//
// 
// References: https://github.com/joshsager/Fancy-Pants-Conference-Info-Wall/blob/master/RandomKittenSpreadsheet/SimpleSpreadsheetManager.pde

class Highscores extends MenUI {
  SpreadsheetService service;
  WorksheetEntry wsEntry;
  WorksheetFeed wsFeed;
  ListFeed listFeed;
  List listEntries;
  
  String[] theNames = new String[10];
  String[] theScores = new String[10];
  String spreadsheet_name = "Space Invaders Highscores";
  int spreadsheet_index = 0;
  
  Highscores() {
    listFeed = new ListFeed();
    CellFeed cf = new CellFeed();
    wsFeed = new WorksheetFeed();
    service = new SpreadsheetService("test");
    
    //Get spreadsheets feed
    try {
      service.setUserCredentials("MPGD.Space.Invaders",  "exercise35");
      URL feedURL = new URL("http://spreadsheets.google.com/feeds/spreadsheets/private/full/");
      SpreadsheetFeed feed = service.getFeed(feedURL, SpreadsheetFeed.class);
      for(SpreadsheetEntry entry: feed.getEntries()) {
        if(entry.getTitle().getPlainText().equals(spreadsheet_name)) {
          break;  //Break out of this for loop if right sheet was found.
        }
        spreadsheet_index += 1;  //Increase index to check if the next sheet is the right one.
      }
      SpreadsheetEntry se = feed.getEntries().get(spreadsheet_index);
      wsEntry = se.getWorksheets().get(0);
      println("Found worksheet ''" + se.getTitle().getPlainText() + "'' on Google Drive");
    }
    catch(Exception e) { println("Couldn't find a worksheet!"); }
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
  void setCellContet(String tag, int r, String val) {
    ListEntry le = (ListEntry)listEntries.get(r);    
    le.getCustomElements().setValueLocal(tag, val);
    try {
      ListEntry updatedRow = le.update();
    }
    catch (Exception e){ println(e.toString()); }
  }
  
  void updateHighscores() {
    //Get list feed URL.
    List worksheets = wsFeed.getEntries();
    try {
      URL listFeedURL = new URL("http://spreadsheets.google.com/feeds/list/1oZZcCmDsuZIvEOVTPXqtqi3vzNukf2B-0aItSb-tXtU/od6/private/full");
      URL listFeedUrl = wsEntry.getListFeedUrl();
      ListFeed lf2 = new ListFeed();
      listFeed = service.getFeed(listFeedUrl, lf2.getClass());
    }
    catch(Exception e) { println(e.toString()); }
    
    listEntries = listFeed.getEntries();
    for(int i = 0; i < theNames.length; i++) {
      theNames[i] = getCellContent(0, i);
      theScores[i] = getCellContent(1, i);
    }
  }
  
  void display() {
    //Draw highscore screen.
    fill(0, 200);
    rectMode(CENTER);
    rect(width/2, height/2, width, height);
    drawBackground(height*0.65, height*0.625);
    fill(0, 255);
    stroke(255);
    strokeWeight(labelHeight/10);
    rect(width/2, height/2, width/2.5, height/1.8);
    textAlign(CENTER, CENTER);
    textSize(labelHeight*2);
    fill(0, 255, 0);
    text("HighScores", width/2 + labelHeight/8, labelHeight*4.5);
    displayBtns(height/4 + labelHeight*3, 1);
        
    for(int i = 0; i < theNames.length; i++) {
      String _numPlace = nf(i+1, 0) + ". ";
      String _name = theNames[i];
      String _score = " : " + theScores[i];
      float _x = 0;
      float _y = height/2 - height/4 + labelHeight*0.75 + (labelHeight*1.5)*i;
      
      if(i <= 2) {
        stroke(255);
        textSize(labelHeight*(1.45 - 0.15*i));
        _x = width/2 + labelHeight*1.5 - textWidth(_numPlace) - textWidth(_name)/2;
        if(i == 0) { fill(255, 215, 0); }
        if(i == 1) { fill(150, 90, 56); }
        if(i == 2) { fill(148, 148, 148); }
      }
      else {
        textSize(labelHeight);
        _x = width/2 - width/6.5 + labelHeight*1.5 + textWidth("10. ");
        fill(255);
      }
      
      textAlign(RIGHT, CENTER);
      text(_numPlace, _x, _y);
      textAlign(LEFT, CENTER);
      text(_name, _x, _y);
      text(_score, _x + textWidth(_name), _y);
    }
  }
}
