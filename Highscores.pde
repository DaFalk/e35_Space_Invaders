//
// 
// References: https://github.com/joshsager/Fancy-Pants-Conference-Info-Wall/blob/master/RandomKittenSpreadsheet/SimpleSpreadsheetManager.pde

class Highscores {
  SpreadsheetService service;
  WorksheetEntry wsEntry;
  WorksheetFeed wsFeed;
  List listEntries;
  
  String[] theNames = new String[10];
  String[] theScores = new String[10];
  String spreadsheet_name = "Space Invaders Highscores";
  int spreadsheet_index = 0;
  
  Highscores() {
    ListFeed listFeed = new ListFeed();
    CellFeed cf = new CellFeed();
    WorksheetFeed ws = new WorksheetFeed();
    
    service = new SpreadsheetService("test");
    //Get spreadsheets feed
    try {
      service.setUserCredentials("MPGD.Space.Invaders",  "exercise35");
      URL feedURL = new URL("http://spreadsheets.google.com/feeds/spreadsheets/private/full/");
      SpreadsheetFeed feed = service.getFeed(feedURL, SpreadsheetFeed.class);
      for(SpreadsheetEntry entry: feed.getEntries()) {
        if(entry.getTitle().getPlainText().equals(spreadsheet_name)) {
          break;
        }
        spreadsheet_index += 1;
      }
      SpreadsheetEntry se = feed.getEntries().get(spreadsheet_index);
      wsEntry = se.getWorksheets().get(0);
      println("Found worksheet ''" + se.getTitle().getPlainText() + "'' on Google Drive");
    }
    catch(Exception e) {
      println(e.toString());
    }
    
    List worksheets = ws.getEntries();
    
    //Get list feed URL
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
  
  void display() {
    fill(255);
    textSize(menUI.labelHeight);
    textAlign(LEFT, CENTER);
    for(int i = 0; i < 10; i++) {
      String _highScore = nf(i+1, 0) + ". - " + theNames[i] + " : " + theScores[i];
      text(_highScore, width/2 - width/4.5, height/2 - height/4 + menUI.labelHeight*0.75 + (menUI.labelHeight*1.5)*i);
    }
  }
}
