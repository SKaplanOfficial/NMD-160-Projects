/* Stephen Kaplan - September 25th, 2018 - NMD 160 Frogger Project
 This program is a recreation of Konami's classic "Frogger" game using a modular approach.
 Use the arrow keys to move frogger one "hop" at a time. Avoid colliding with vehicles.
 Contact with river water results in immediate loss of one life.
 After 5 lives, the game is over.
 
 Press D to enter debug mode. Once there, press Shift+. to switch to the next scene, or Shift+, to go back to the previous scene.
 In debug mode, press the down arrow to move frogger backward.
 
 Version 0.0.1
 */


// State Management Variables
ArrayList<Scene> scenes = new ArrayList<Scene>();
ArrayList<Notification> notifications = new ArrayList<Notification>();
int notificationAmount;

int currentScene = 0;
int sceneAmount;            // Set by getFolders()
boolean debug = false;      // Press d to toggle

// Utility Variables
String version = "0.0.1";
String divider = new String(new char[5]).replace("", "-");
float heightOfRow;

String logPath = "logs/"+year()+"/"+month()+"/"+day()+".txt";
boolean doesLogExist;


// Runs once - Add start menu later, current initializes into first scene
void setup() {
  size(800, 600); // Add way to change size later

  doesLogExist = getFolders("logs") > 0 ? true: false;

  // Logging for debugging purposes, see the logs subfolder to see all info
  log("\n"+divider+getExactTime()+divider+"\n");
  log("Initializing Frogger (Version "+version+")");

  // Find scenes & add to array
  log("Loading scenes.");
  sceneAmount = getFolders("Scenes");
  log("Number of scenes found: "+sceneAmount+".");

  for (int i=0; i<sceneAmount; i++) {
    scenes.add(new Scene(scenes.size()));
  }

  // Load initial scene (To be changed to start menu later)
  log("Loading Data For Scene 0");
  scenes.get(0).loadData();

  log("Loading Assets For Scene 0 - "+scenes.get(0).getName());
  scenes.get(0).loadAssets();

  addNotification(scenes.get(currentScene).getName()+" - "+scenes.get(currentScene).getCatchPhrase(), 0, height/2-100, width, 200, -1, false);
}


// Runs ~60 times per second, add FPS monitor to debug mode later
void draw() {
  // All objects in scene are managed within scene class
  scenes.get(currentScene).update();
  scenes.get(currentScene).display();

  for (int i=0; i<notifications.size(); i++) {
    notifications.get(i).display();
    notifications.get(i).update();
  }
}

void keyPressed() {
  // Toggle debug mode
  if (key == 'd') {
    if (debug) {
      addNotification("Debug mode exited.", 150);
      log("Debug mode exited.");
    } else {
      addNotification("Debug mode entered.", 150);
      log("Debug mode entered.");
    }

    debug = !debug;
  } else if (debug) {
    // If debug mode is on, use separate debug listener
    debugKeyPressed();
  }

  // If frog object is active, use arrow key listener
  if (scenes.get(currentScene).frogger != null) {
    Frog frog = scenes.get(currentScene).frogger;
    if (debug || frog.alive() && frog.isNotDying()) {
      if (keyCode == UP) {
        frog.moveUp();
      } else if (keyCode == DOWN && debug) {
        // Disabe downward movement unless debug mode is on
        frog.moveDown();
      } else if (keyCode == LEFT) {
        frog.moveLeft();
      } else if (keyCode == RIGHT) {
        frog.moveRight();
      }

      if (keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT) {
        for (int i=0; i<notifications.size(); i++) {
          if (notifications.get(i).timer == -1) {
            notifications.get(i).timer = 0;
          }
        }
      }
    }
  }
}


// Debug mode key listener
void debugKeyPressed() {
  if (debug) {
    // Move to next scene
    if (key == '>' && currentScene < sceneAmount-1) {
      // Unload unnecessary objects and images
      scenes.get(currentScene).unloadAssets();
      clearPersistantNotifications();

      currentScene += 1;

      // Load next scene
      log("Loading Data For Scene "+currentScene);
      scenes.get(currentScene).loadData();

      log("Loading Assets For Scene "+currentScene + " - "+scenes.get(currentScene).getName());
      scenes.get(currentScene).loadAssets();

      addNotification(scenes.get(currentScene).getName()+" - "+scenes.get(currentScene).getCatchPhrase(), 0, height/2-100, width, 200, -1, false);
    }

    // Move to previous scene
    else if (key == '<' && currentScene > 0) {
      // Unload unnecessary objects and images
      scenes.get(currentScene).unloadAssets();
      clearPersistantNotifications();

      currentScene -= 1;

      // Load previous scene
      log("Loading Data For Scene "+currentScene);
      scenes.get(currentScene).loadData();

      log("Loading Assets For Scene "+currentScene + " - "+scenes.get(currentScene).getName());
      scenes.get(currentScene).loadAssets();

      addNotification(scenes.get(currentScene).getName()+" - "+scenes.get(currentScene).getCatchPhrase(), 0, height/2-100, width, 200, -1, false);
    }
  }
}


void addNotification(String msg, int timer) {
  notifications.add(new Notification(msg, timer, notificationAmount));
}

void addNotification(String msg, int timer, color c) {
  notifications.add(new Notification(msg, timer, notificationAmount, c));
}

void addNotification(String msg, float targetX, float targetY, float sizeX, float sizeY, int timer, boolean includeInList) {
  notifications.add(new Notification(msg, targetX, targetY, sizeX, sizeY, timer, notificationAmount, includeInList));
}

void addNotification(String msg, float targetX, float targetY, float sizeX, float sizeY, int timer, boolean includeInList, color c) {
  notifications.add(new Notification(msg, targetX, targetY, sizeX, sizeY, timer, notificationAmount, includeInList, c));
}

void clearPersistantNotifications() {
  for (int i=0; i<notifications.size(); i++) {
    if (notifications.get(i).timer == -1) {
      notifications.get(i).timer = 0;
    }
  }
}

// Count folders within Scenes directory
// Technically counts all files. This method should only work on UNIX systems (including MacOS).
// Change to better method eventually, but this works for now.
int getFolders(String dir) {
  int folders = 0;

  java.io.File folder = new java.io.File(sketchPath(dir));
  String[] list = folder.list();
  for (int i=0; i<list.length; i++) {
    if (!list[i].equals(".DS_Store")) {
      folders++;
      if (dir == "Scenes") {
        log("Found scene " + list[i] + ".");
      }
    }
  }
  return folders;
}


// Append log messages to log file
void log(String message) {
  File file = new File(sketchPath(logPath));
  boolean newLogFile = !file.exists();
  
  // Appending data
  String[] newMessage = {message};
  String[] pastMessages = null;
  if (doesLogExist) {
    pastMessages = loadStrings(logPath);
  }
  String[] logMessage;

  if (pastMessages == null && doesLogExist == false) {
    String[] firstLog = {"VERY FIRST RUN OF FROGGER"};
    logMessage = concat(firstLog, newMessage);
    doesLogExist = true;
  } else if (pastMessages == null && newLogFile == true) {
    logMessage = newMessage;
    newLogFile = false;
  } else {
    logMessage = concat(pastMessages, newMessage);
  }

  // Saving data, reporting to console
  saveStrings(logPath, logMessage);
  println(message);
}


String getExactTime() {
  return year()+"/"+month()+"/"+day()+" @ "+hour()+":"+minute()+":"+second();
}