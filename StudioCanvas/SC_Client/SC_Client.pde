// Stephen Kaplan 2018
// NMD 160
// November 25th, 2018

// Studio Canvas Server
// This program allows users to draw on a shared canvas


//*****************************//
//   IMPORTS, VARIABLES, ETC   //
//*****************************//

import processing.net.*;             // No install needed
import de.voidplus.leapmotion.*;     // Install from: https://github.com/nok/leap-motion-processing
                                     // Required software: https://www.leapmotion.com/setup/desktop/ (Must be running while using LeapMotion)

// SERVER
Client c;
int port = 10001;

// COMPANION
String random_key = "";
boolean companion_connected = false;

// PACKET INFORMATION
String input;
String output;
int data[];

// STATE VARIABLES
int myMode = 0;
int incomingMode = 0;
float red = 255;
float green = 255;
float blue = 255;
float alpha = 255;
float size = 5;
color bg = color(12);

// INTERACTION
LeapMotion leap;
boolean useLeapMotion = false;      // Set to true if you wish to use LeapMotion

// UTILITY
int rateLimit = 15; // Limit frameRate, -1 => No limit
String version = "1.0";



//*****************************//
//            SETUP            //
//*****************************//

void setup() {
  fullScreen();
  background(bg);
  stroke(0);

  if (useLeapMotion) {                           // Activate LeapMotion if needed
    leap = new LeapMotion(this).allowGestures();
  }

  // Key = Time (seconds) + Random Number (3 digits) + Random Character
  random_key = second()+""+int(random(100, 999))+char(int(random(65, 91)));

  if (rateLimit > 0) {       // Framerate limited to ensure server can handle incoming data
    frameRate(rateLimit);
  }

  //c = new Client(this, "127.0.0.1", port);     // Localhost
  c = new Client(this, "52.91.206.159", port);   // Connect to the server's IP address and port

  c.write(random_key+"|CONNECT");                // Send connection message to server
}



//*****************************//
//            DRAW             //
//*****************************//

void draw() 
{
  if (mousePressed == true) {
    // Send previous mouse location, current mouse location, and mode to the server to be relayed to othe clients
    output = pmouseX + " " + pmouseY + " " + mouseX + " " + mouseY + " " + myMode + "\n";
    c.write(output);
  }
  
  
  // Receive and interpret data from server
  if (c.available() > 0) {
    input = c.readString();

    try {
      if (input.contains("|")) {
        // Extract settings from data, print to console
        String item = input.substring(0, input.indexOf("|"));
        String value = input.substring(input.indexOf("|")+1, input.length()).replace("|b", "");
        println(value+" => "+item);

        
        // Change state variables according to extracted item, value
        if (item.equals("Red")) {                              // SLIDERS
          red = map(parseFloat(value), 0, 100, 0, 255);
        } else if (item.equals("Green")) {
          green = map(parseFloat(value), 0, 100, 0, 255);
        } else if (item.equals("Blue")) {
          blue = map(parseFloat(value), 0, 100, 0, 255);
        } else if (item.equals("Alpha")) {
          alpha = map(parseFloat(value), 0, 100, 0, 255);
        } else if (item.equals("Size")) {
          size = map(parseFloat(value), 0, 100, 0, 255);
        } else if (item.equals("Line")) {                      // FIRST ROW BUTTONS
          myMode = 0;
        } else if (item.equals("Scatter")) {
          myMode = 1;
        } else if (item.equals("Sparkler")) {
          myMode = 2;
        } else if (item.equals("Triangle")) {
          myMode = 3;
        } else if (item.equals("Square")) {
          myMode = 4;
        } else if (item.equals("Hatch (P)")) {                 // SECOND ROW BUTTONS
          myMode = 5;
        } else if (item.equals("Hatch (R)")) {
          myMode = 6;
        } else if (item.equals("Stripes")) {
          myMode = 7;
        } else if (item.equals("Columns")) {
          myMode = 8;
        } else if (item.equals("Wave")) {                      // THIRD ROW BUTTONS
          myMode = 9;
        } else if (item.equals("Bubble")) {
          myMode = 10;
        } else if (item.equals("Triangle Scatter")) {
          myMode = 11;
        } else if (item.equals("Square Scatter")) {
          myMode = 12;
        } else if (item.equals("Blur")) {                      // EXPERIMENTAL BUTTONS
          myMode = 13;
        } else if (item.equals("Clear")) {                     // SINGLE USE BUTTONS
          background(bg);
        } else if (item.equals("Set Background")) {
          bg = color(red, green, blue);
          background(bg);
        }
      } else {
        input = input.substring(0, input.indexOf("\n"));  // Only up to the newline
        data = int(split(input, ' '));                    // Split values into an array

        stroke(red, green, blue, alpha);                  // Draw according received coordinates and state variables
        fill(red, green, blue, alpha);

        incomingMode = data[4];

        if (incomingMode == 0) {
          lines(data, size);
        } else if (incomingMode == 1) {
          scatter(data, size);
        } else if (incomingMode == 2) {
          sparkler(data, size);
        } else if (incomingMode == 3) {
          tri(data, size);
        } else if (incomingMode == 4) {
          square(data, size);
        } else if (incomingMode == 5) {
          phatch(data, size);
        } else if (incomingMode == 6) {
          rhatch(data, size);
        } else if (incomingMode == 7) {
          stripes(data, size);
        } else if (incomingMode == 8) {
          columns(data, size);
        } else if (incomingMode == 9) {
          wave(data, size);
        } else if (incomingMode == 10) {
          bubble(data, size);
        } else if (incomingMode == 11) {
          triScatter(data, size);
        } else if (incomingMode == 12) {
          squareScatter(data, size);
        } else if (incomingMode == 13) {
          blur(data, size);
        }
      }
    } 
    catch (Exception e) {
      // Catches all errors – minimize chance of server crashing, however this is not a good practice in general
      println("Encountered an error. Corrupted packet?");
    }
  }

  if (!companion_connected && frameCount < 500) {
    // Text will dissapear after background change or clear
    text("Connect companion: "+random_key, 10, 10);
  }

  if (useLeapMotion && leap.getHands().size() > 0) {
    // Leap motion interaction -> Pointer finger in place of mouse, pinch to pause input
    if (leap.getHands().get(0).getPinchStrength() < 0.2) {
      mouseX = int(leap.getHands().get(0).getIndexFinger().getPosition().x);
      mouseY = int(leap.getHands().get(0).getIndexFinger().getPosition().y);
      mousePressed = true;
    } else {
      mousePressed = false;
    }
  }
}