class AudioHandler {
  AudioHandler() {
  }
  
  void manage() {
    if(gamePaused) { audioPlayer[0].setGain(-10); }
    else { audioPlayer[0].setGain(0); }
    playThemeSong();
  }
  
  void playThemeSong() {
    if(!audioPlayer[0].isPlaying()) {
      audioPlayer[0].rewind();
      audioPlayer[0].play();
    }
  }
  
  void playSFX(int SFXIndex) {
    audioPlayer[SFXIndex].rewind();
    audioPlayer[SFXIndex].play();
  }
}
