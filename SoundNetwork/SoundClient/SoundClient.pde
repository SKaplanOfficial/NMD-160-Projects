// Stephen Kaplan 2018
// NMD 160
// December 17th, 2018

// Sound Network Client
// This program connects to the SoundServer to visualize audio

//*****************************//
//   IMPORTS, VARIABLES, ETC   //
//*****************************//

// IMPORTS
import processing.net.*;      // Network library - No install needed

// NETWORK
Client myClient;
DisposeHandler dh;            // Detects any form of stopping the program (ESC, Stop button, etc)
int port = 10001;             // Port must be same as server port!
String id = "PC";             // Server uses the ID to determine whether to send data to this client or not

color bg = color(10);         // Initial background color
float red = 10;               // Background colors controlled by RGB sliders on ServerController
float green = 10;
float blue = 10;

int mode = 0;                 // Mode 0: Visual_One



//*****************************//
//       SETUP  FUNCTION       //
//*****************************//

void setup() {
  fullScreen(P3D);
  dh = new DisposeHandler(this);

  //myClient = new Client(this, "localhost", port);     // Local server used during testing
  myClient = new Client(this, "141.114.245.235", port); // Server used during presentation

  myClient.write(id+" has connected!"); // Announce user's arrival
}



//*****************************//
//        DRAW FUNCTION        //
//*****************************//

void draw() {
  try {
    if (myClient.available() > 0) {               // Are there messages being sent to the Client?
      String msg = myClient.readString();         // Store them
      msg = msg.substring(0, msg.indexOf("\n"));  // Only up to the newline

      if (msg.contains("Tablet")) {               // If the message comes from a tablet
        if (msg.contains("|1|")) {                // If the message is a number -> Clear screen, change mode
          clearScreen();
          mode = 0;
        } else if (msg.contains("|2|")) {
          clearScreen();
          mode = 1;
        } else if (msg.contains("|3|")) {
          clearScreen();
          mode = 2;
        } else if (msg.contains("|4|")) {
          clearScreen();
          mode = 3;
        } else if (msg.contains("|5|")) {
          clearScreen();
          mode = 4;
        } else if (msg.contains("Red")) {        // If the message is a color and a number, update corresponding color
          String value = msg.substring(msg.indexOf("Red")+4, msg.indexOf("|b")-1);
          red = map(parseFloat(value), 0, 100, 0, 255);
        } else if (msg.contains("Green")) {
          String value = msg.substring(msg.indexOf("Green")+6, msg.indexOf("|b")-1);
          green = map(parseFloat(value), 0, 100, 0, 255);
        } else if (msg.contains("Blue")) {
          String value = msg.substring(msg.indexOf("Blue")+5, msg.indexOf("|b")-1);
          blue = map(parseFloat(value), 0, 100, 0, 255);
        } else if (msg.contains("Set Background")) {  // If the message is "Set Background", update the background color
          bg = color(red, green, blue);
        }
      } else {  // If the message comes from a PC
        int size = parseInt(msg.substring(0, msg.indexOf(",")));  // Get size of incoming data array
        msg = msg.substring(msg.indexOf(",")+2, msg.length());    // Ignore the size when actually making the array
        String[] data = msg.split(", ");                          // Separate terms of message into usable data elements

        if (data.length != size) {                                // Check for valid data
          throw new IllegalArgumentException();
        }

        switch (mode) {             // Respond to data
        case 0:
          show_visual_one(data);    // Visuals increase in complexity at number increases in an effort to see limitations of the system
          break;
        case 1:
          show_visual_two(data);
          break;
        case 2:
          show_visual_three(data);
          break;
        case 3:
          show_visual_four(data);
          break;
        case 4:
          show_visual_five(data);
          break;
        }
      }

      myClient.clear();             // Prepare to recieve other messages
    } else {
      renderDataless();
    }
  } 
  catch (Exception e) {
    // println("Encountered error. Corrupt packet?"); // Use for debugging
    renderDataless();  // Show current visual without data, if possible
  }
}


void renderDataless() {
  // No data provided -> If possible, run visual without data to help continuity
  switch (mode) {
  case 2:
    show_visual_three();
    break;
  case 3:
    show_visual_four();
    break;
  case 4:
    show_visual_five();
    break;
  }
}


void clearScreen() {
  // Set background color
  background(bg);

  // Memory management
  points.clear();
  fallingPoints.clear();
  dots.clear();
}



// Disconnect Event
public class DisposeHandler {
  DisposeHandler(PApplet pa) {
    pa.registerMethod("dispose", this);
  }

  public void dispose() {   
    // Tell server that this client has lost connection for whatever reason
    myClient.write("|DISCONNECT");
  }
}