// Stephen Kaplan 2018
// NMD 160
// November 26th, 2018

// Stuio Canvas Server
// This program provides tools for StudioCanvas clients


//*****************************//
//   IMPORTS, VARIABLES, ETC   //
//*****************************//

import processing.net.*;       // No install needed

// SERVER CONNECTION
Client c;
int port = 10001;

// PACKET INFORMATION
String input;
String output;
int data[];

// STATE VARIABLES
int scene = 0;
int counter = 0;

// INPUT VARIABLES
String key_input = "";
boolean keyboard = false;

// UTILITY
String version = "1.0";
int rateLimit = 15;           // Limit framerate, -1 => No limit



//*****************************//
//            SETUP            //
//*****************************//

void setup() {
  fullScreen();
  background(12);

  orientation(LANDSCAPE);    // Force specific orientation to improve experience

  if (rateLimit > 0) {       // Framerate limited to ensure server can handle incoming data
    frameRate(rateLimit);
  }

  //c = new Client(this, "127.0.0.1", port);     // Localhost
  c = new Client(this, "52.91.206.159", port);   // Connect to the server's IP address and port
}



//*****************************//
//            DRAW             //
//*****************************//

void draw() {

  switch(scene) {
  case 0:
    // Have user enter client key
    showKeyInput();
    break;
  case 1:
    // Show connection status
    showConnecting();
    break;
  case 2:
    // When connected, show controls
    showControls();
    break;
  }

  // Receive data from server
  if (c.available() > 0) {
    input = c.readString();

    if (!input.equals(output)) {            // Don't repeat data, compare input and output
      try {
        if (input.contains("|ATTACHED")) {  // Once attached, proceed to controls
          if (scene == 1) {
            scene = 2;
          }
          println("Success!");
        } else {

          input = input.substring(0, input.indexOf("\n"));  // Only up to the newline
          data = int(split(input, ' '));                    // Split values into an array

          stroke(0);
          line(data[0], data[1], data[2], data[3]);         // Draw a line using received coordinates
        }
      } 
      catch (Exception e) {
        // Catches all errors – minimize chance of server crashing, however this is not a good practice in general
        println("Encountered an error. Corrupted packet?");
      }
    }
  }
}


void keyPressed() {
  // Only need keyboard listener during key input
  if (scene == 0) {
    key_input_listener();
  }
}


void mousePressed() {
  if (scene == 0) {      // Show keyboard when user taps the screen
    if (!keyboard) {
      openKeyboard();
      keyboard = true;
    } else {             // Close when user taps outside of keyboard
      closeKeyboard();
      keyboard = false;
    }
  } else if (scene == 2) {
    for (Button b : buttons.values()) {
      if (b.over()) {
        if (b.isSingleUse()) {
          // Clear, background setting -> Broadcast once, don't change any other settings
          c.write(b.getName()+"|b");
        } else if (b.isBroadcast()) {
          // Other specified broadcasts
          singleEnabled(b);
          c.write(b.getName()+"|b");
        } else {
          // Everything else, send value directly to attached client, only allow one setting to be enabled at a time
          singleEnabled(b);
          c.write(b.getName()+"|"+b.getValue());
        }
      }
    }
  }
}


void mouseReleased() {
  // Determine value of adjusted slider and transmit
  for (Slider s : sliders.values()) {
    if (mouseX > s.getXStart() && mouseX < s.getXStart()+s.getWidth() && mouseY > s.getYStart() && mouseY < s.getYStart()+s.getHeight()) {
      if (s.isBroadcast()) {
        // Broadcast if specified
        c.write(s.getName()+"|"+s.getValue()+"|b");
      } else {
        c.write(s.getName()+"|"+s.getValue());
      }
    }
  }
}