//
// http://forum.processing.org/one/topic/nullpointerexception.html
// References: http://forum.processing.org/two/discussion/2417/how-do-i-retrieve-data-from-google-spreadsheet/p1
//           :
class Highscores {
  String[] names = new String[10];
  String[] theScores = new String[10];
  String spreadsheet_name = "Space Invaders Highscores";
  int spreadsheet_index = 0;
  
  Highscores() {
    service = new SpreadsheetService("test");
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
      println("Found worksheet " + se.getTitle().getPlainText());
    }
    catch(Exception e) {
      println(e.toString());
    }
  }
  
  void display() {
//    fill(255);
//    textSize(labelHeight);
//    textAlign(CENTER, CENTER);
//    for(int i = 0; i < 10; i++) {
//      String _highScores = nf(i+1, 0) + ". - " + "AAA : " + totalScore;
//      text(_highScores, width/2, height/2 - height/4 + labelHeight*0.75 + (labelHeight*1.5)*i);
//    }
  }
}
