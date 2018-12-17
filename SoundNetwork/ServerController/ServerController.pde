// Stephen Kaplan 2018
// NMD 160
// December 17th, 2018

// Sound Network Controller
// This program provides a UI for controlling the SoundServer visualizer.

//*****************************//
//   IMPORTS, VARIABLES, ETC   //
//*****************************//

// IMPORTS
import processing.net.*;

// NETWORK
Client myClient;
int port = 10001;       // Port must be same as server port!
String id = "Tablet";   // Server uses the ID to determine whether to send data to this client or not


//*****************************//
//       SETUP  FUNCTION       //
//*****************************//

void setup() {
  fullScreen();                                         // Fullscreen is idea for tablets/phones

  //myClient = new Client(this, "localhost", port);     // Local server used during testing
  myClient = new Client(this, "141.114.245.235", port); // Server used during presentation

  myClient.write(id+" has connected!");                 // Announce user's arrival
}



//*****************************//
//        DRAW FUNCTION        //
//*****************************//

void draw() {  
  showControls(); // Show UI
}


void mousePressed() {  
  for (Button b : buttons.values()) {
    if (b.over()) {
      if (b.isSingleUse() && b.isBroadcast()) {
        // Clear, background setting -> Broadcast once, don't change any other settings
        myClient.write(id+"|"+b.getName()+"|b");
      } else if (b.isSingleUse()) {
        // Clear, background setting -> Send only to server, don't change any other settings
        myClient.write(id+"|"+b.getName());
      } else if (b.isBroadcast()) {
        // Other specified broadcasts
        singleEnabled(b);
        myClient.write(id+"|"+b.getName()+"|b");
      } else {
        // Everything else, send value directly to attached client, only allow one setting to be enabled at a time
        singleEnabled(b);
        myClient.write(id+"|"+b.getName()+"|"+b.getValue());
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
        myClient.write(id+"|"+s.getName()+"|"+s.getValue()+"|b");
      } else {
        myClient.write(id+"|"+s.getName()+"|"+s.getValue());
      }
    }
  }
}