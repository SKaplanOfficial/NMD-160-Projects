// Stephen Kaplan 2018
// NMD 160
// November 26th, 2018

// Stuio Canvas Server
// This program creates a server to link users of StudioCanvas together


//*****************************//
//   IMPORTS, VARIABLES, ETC   //
//*****************************//

import processing.net.*;       // No install needed

// SERVER
Server s;                      // Server and client
Client c;
int port = 10001;              // Port number (Must be same as client)

// UTILITY
String version = "1.0";
String input;                  // Information received from clients

// LISTS
ArrayList<User> users = new ArrayList<User>();



//*****************************//
//            SETUP            //
//*****************************//

void setup() {
  s = new Server(this, port);  // Start server on specified port
  surface.setVisible(false);   // Hide window, use console as sole output
}



//*****************************//
//            DRAW             //
//*****************************//

void draw() {

  // Receive data from client
  c = s.available();

  // Interpret data
  if (c != null) {
    try {
      input = c.readString();

      if (input.contains("|CONNECT")) {
        // Client connection
        println("User connected: "+input.substring(0, input.indexOf("|"))); // Add new user with client object and name
        users.add(new User(c, input.substring(0, input.indexOf("|"))));     // Add new user with client object and name
      } else if  (input.contains("|ATTACH")) { 
        // StudioCanvas Companion attachment
        println(input);

        String inputKey = input.substring(0, input.indexOf("|"));           // Extract key from input            

        for (User u : users) {
          if (u.getKey().equals(inputKey) && u.getAttached() == null) {     // Find user with matching key
            u.attach(c);                                                    // Attach new device
            c.write("|ATTACHED");
          } else if (u.getKey().equals(inputKey) && u.getAttached() != null) {  // Send blocked message if a device is already attached
            c.write("|BLOCKED");
            println("Blocked!");
          }
        }
      } else if (input.contains("|b")) {
        // Messages specifically marked for broadcasts
        println(input);
        s.write(input);
      } else if (input.contains("|")) {
        // All other commands are denoted with |
        println(input);
        for (User u : users) {
          if (u.getAttached().equals(c)) {
            u.getClient().write(input);       // Send commands from attached devices to their corresponding client
          }
        }
      } else {
        // Relay any other kind of message to all clients
        // This is not secure, but works for the purposes of the assignment
        s.write(input);
      }
    } 
    catch (Exception e) {
      // Catches all errors – minimize chance of server crashing, however this is not a good practice in general
      println("Encountered an error. Corrupted packet?");
    }
  }
}