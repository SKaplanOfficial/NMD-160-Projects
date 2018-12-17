// Stephen Kaplan 2018
// NMD 160
// December 17th, 2018

// Sound Network Controller
// This program creates a server to link devices of the SoundNetwork together.

//*****************************//
//   IMPORTS, VARIABLES, ETC   //
//*****************************//

// IMPORTS
import ddf.minim.analysis.*;         // Sound library - Download from Sketch -> Import Library -> Add Library -> Search Minim -> Install
import ddf.minim.*;
import processing.net.*;             // Network library - No install needed

// SERVER
Server myServer;                     // Server Object
int port = 10001;                    // Helps other computers connect to the server, if properly set up
String msg;                          // Stores messages coming IN
boolean myServerRunning = true;      // Server open?

// REGULATORS
int messagesPos = 0;                 // Determines starting position of messages
boolean isGoing = false;             // Play music or not - control with ENTER
int currentSong = 1;                 // Current song being played
int packetLimiter = 2;               // Controls how often packets are sent to each client. 0 for no limit.

// MINIM (SOUND)
Minim       minim;
AudioPlayer song;                    // Selected song
AudioInput in;                       // Live audio input
FFT         fft;

// LISTS
ArrayList<String> messages = new ArrayList<String>();
ArrayList<User> users = new ArrayList<User>();
// Using an ARRAYLIST so that we can control what messages are displayed on screen and when



//*****************************//
//       SETUP  FUNCTION       //
//*****************************//

void setup() {
  // Create window
  size(500, 300);
  myServer = new Server(this, port);                                  // Server open on specified port

  // Minim Setup
  minim = new Minim(this);
  song = minim.loadFile("Alan_Spiljak_-_04_-_Empty_days.mp3", 1024);  // First song -> First button
  fft = new FFT( song.bufferSize(), song.sampleRate() );              // Breaks down soundfile into individual frequencies to work with
  
  
  surface.setResizable(true); // Resizable window to allow more messages to be seen if desired
}



//*****************************//
//        DRAW FUNCTION        //
//*****************************//

void draw() {
  background(0);            // Black background

  fft.forward( song.mix );  // Step forward in the song

  stroke(255);
  strokeWeight(0.5);
  if (currentSong == 5) {   // 5 = live audio input, different code needed to visualize
    for (int i = 0; i < in.bufferSize() - 1; i+=5) {
      line( i, height, i, height-in.left.get(i)*200);  // Visual on top and bottom gives context that live input is handled differently than mp3 files
      line( i, 0, i, in.right.get(i)*200);
    }
  } else {
    for (int i=0; i<fft.specSize(); i+=5) {
      line(i, height, i, height-fft.getFreq(i)*10);    // Length of line determined by amptitude at specified frequency
    }
  }

  if (myServerRunning == true) {                       // If the server is open
    Client sender = myServer.available();              // Find users connected
    if (sender != null && sender.available() > 0) {    // Find any messages sent to the server
      msg = sender.readString();                       // Store those messages in msg variable


      boolean found = false;
      for (int i=0; i<users.size(); i++) {
        if (users.get(i).me.equals(sender)) {          // Check to see if sender is already a member of the users array
          found = true;
        }
      }

      if (!found) {
        if (msg.contains("Tablet")) {                  // If no current user exists, add a new one with the specified type.
          users.add(new User(sender, users.size(), "Tablet"));
        } else {
          users.add(new User(sender, users.size(), "PC"));
        }
      }


      if (msg.equals("|DISCONNECT")) {                // Remove user from user array upon disconnection
        messages.add("Detected disconnect: "+sender);
        for (int i=0; i<users.size(); i++) {
          if (users.get(i).me.equals(sender)) {
            users.remove(i);
          }
        }
      } else if (msg.contains("|b")) {               // Broadcast messages with the "|b" tag to all connected clients
        messages.add(msg+" (Broadcasted to "+users.size()+" clients)");
        for (User u : users) {
          u.me.write(msg+"\n");
        }
      } else {
        messages.add(msg);  // If the message is not tag for broadcast or disconnect, add it to the message array.

        // Change to specified song when a message contains its name
        if (msg.contains("Empty Days")) {
          loadSong("Alan_Spiljak_-_04_-_Empty_days.mp3", 1);
        } else if (msg.contains("Beyond The Line")) {
          loadSong("bensound-beyondtheline.mp3", 2);
        } else if (msg.contains("Endless Motion")) {
          loadSong("bensound-endlessmotion.mp3", 3);
        } else if (msg.contains("Seven Lights")) {
          loadSong("Sergey_Cheremisinov_-_02_-_Seven_Lights.mp3", 4);
        }

        if (msg.contains("Footprints (Piano)")) {
          loadSong("FootprintsPiano.mp3", 0);
        } else if (msg.contains("Footprints")) {
          loadSong("Footprints.mp3", 0);
        } else if (msg.contains("Baba Yetu")) {
          loadSong("BabaYetu.mp3", 0);
        } else if (msg.contains("Elastic Heart")) {
          loadSong("ElasticHeart.mp3", 0);
        }


        // Change to live audio input when specifed
        if (msg.contains("Live")) {
          song.pause();            // Pause current song
          currentSong = 5;         // Set song to live input
          in = minim.getLineIn();  // Gets microphone input
        }


        // Play or pause music when specified
        if (msg.contains("Play/Pause")) {
          isGoing = !isGoing;
          if (isGoing) {
            song.loop();
          } else {
            song.pause();
          }
        }
      }
    }

    messagesUI(); // Show messages
  }

  if (isGoing == true) {                    // If a song is playing
    for (int i=0; i<users.size(); i++) {    // For each user
      users.get(i).update();                // Update that user's state
    }
  }

  // Change amount of messages displayed based on window size
  if (messages.size()-messagesPos > int((height-32)/12) && messages.size() > 0) {
    messagesPos += 1;
  }
} // END OF DRAW FUNCTION



//*****************************//
//       USER  INTERFACE       //
//*****************************//

void messagesUI() {                                    // Stored in separate function in case you want to add FEATURES
  for (int i=messagesPos; i<messages.size(); i++) {    // For all messages in the ArrayList
    text(messages.get(i), 5, (i-messagesPos)*12+12);   // Position them based on their location in the ArrayList (i)
    // i-messagePos results in the OLDEST MESSAGES being positioned OFF SCREEN as new ones are added
    
    if ((i-messagesPos)*12+12 < 0) {                   // Remove messages that are no longer being displayed
      messages.remove(i);
    }
  }
}



//*****************************//
//      SHUTDOWN  SCRIPTS      //
//*****************************//

void stopServer() {
  myServer.stop(); // Shutdown server
  exit();          // Close window on shutdown
}