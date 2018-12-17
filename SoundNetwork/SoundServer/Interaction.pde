void keyPressed() {
  if (key == ENTER) {      // Play or pause music
    isGoing = !isGoing;
    if (isGoing) {
      song.loop();
    } else {
      song.pause();
    }
  } else if (key == '1' && currentSong != 1) {  // Play song according to key input
    loadSong("Alan_Spiljak_-_04_-_Empty_days.mp3", 1);
  } else if (key == '2' && currentSong != 2) {
    loadSong("bensound-beyondtheline.mp3", 2);
  } else if (key == '3' && currentSong != 3) {
    loadSong("bensound-endlessmotion.mp3", 3);
  } else if (key == '4' && currentSong != 4) {
    loadSong("Sergey_Cheremisinov_-_02_-_Seven_Lights.mp3", 3);
  } else if (key == '5') {
    song.pause();            // Pause current song
    currentSong = 5;         // Set song to live input
    in = minim.getLineIn();  // Gets microphone input
  }
}


void loadSong(String s, int c) {
  song.pause();       // Pause current song
  currentSong = c;    // Set song number to c

  try {
    // Try to load specified song
    song = minim.loadFile(s, 1024);
    fft = new FFT( song.bufferSize(), song.sampleRate() ); // Breaks down soundfile into individual frequencies to work with
  } 
  catch (Exception e) {
    // If any errors are encountered, load the default song (Song #1)
    println("File not found. Loading default song.");
    song = minim.loadFile("Alan_Spiljak_-_04_-_Empty_days.mp3", 1024);
    fft = new FFT( song.bufferSize(), song.sampleRate() );
  }  

  song.play();        // Play song
  in = null;          // Input object can be discarded
  isGoing = true;     // Resume normal functioning
}