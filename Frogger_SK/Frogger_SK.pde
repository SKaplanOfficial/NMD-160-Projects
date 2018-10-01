/* Stephen Kaplan - October 1st, 2018 - NMD 160 Frogger Project
 This program is a recreation of Konami's classic "Frogger" game using a modular approach.
 Use the arrow keys to move frogger one "hop" at a time. Avoid colliding with vehicles.
 Direct contact with river water results in immediate loss of one life.
 After 5 lives, the game is over. You may choose to restart at the current level, or go back to the start menu.
 
 Press D to enter debug mode. Once there, press Shift+. to switch to the next scene, or Shift+, to go back to the previous scene.
 In debug mode, press the down arrow to move frogger backward.
 
 Version 1.0a
 */

// IMPORTS
import ddf.minim.*;

// Declare the minim variables 
Minim minim;
AudioPlayer powerUpSound;
AudioPlayer riverDeathSound;
AudioPlayer carDeathSound;
AudioPlayer endZoneSound;
AudioPlayer roadSound;
AudioPlayer riverSound;


// State Management Variables
ArrayList<Scene> scenes = new ArrayList<Scene>();
ArrayList<Notification> notifications = new ArrayList<Notification>();

int currentScene = -2;
int sceneAmount;            // Set by getFolders()
boolean debug = false;      // Press d to toggle
boolean startGame = false;
boolean endGame = false;
boolean winGame = false;

// Utility Variables
String version = "1.0a";
String divider = new String(new char[5]).replace("", "-");
float heightOfRow;
int notificationAmount;


String pathToBg = "data/bgImage.png";
PImage bg;

JSONObject scoreObj;           // Information loaded from highscore.json

int currentSelection = 1;
int sizeSetting = 0;
int soundSetting = 0;
int musicSetting = 0;

float performanceModifier = 1;

float score;
float highscore;

String logPath = "logs/"+year()+"/"+month()+"/"+day()+".txt";
boolean doesLogExist;


// Runs once - Add start menu later, current initializes into first scene
void setup() {
  size(800, 600); // Add way to change size later
  background(21);

  doesLogExist = getFolders("logs") > 0 ? true: false;

  minim = new Minim(this);

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

  scoreObj = loadJSONObject("./data/highscore.json");
  highscore = scoreObj.getFloat("highscore");
}


// Runs ~60 times per second, add FPS monitor to debug mode later
void draw() {

  if (startGame && !endGame) {
    textSize(15);
    // All objects in scene are managed within scene class
    scenes.get(currentScene).update();
    scenes.get(currentScene).display();

    if (currentScene != sceneAmount) {
      Frog frog = scenes.get(currentScene).frogger;
      if (frog.deathCount >= frog.maxDeaths && !debug) {
        showLoseScreen();
      } else {
        fill(255);
        textAlign(CENTER, CENTER);
        text("Score: "+round(score)+"\nHigh Score: "+round(highscore), 0, 0, 150, heightOfRow);
        text("Lives: "+(frog.maxDeaths-frog.deathCount), 0, height-heightOfRow, 100, heightOfRow);
      }
    }
  } else if (endGame) {
    showLoseScreen();
  } else if (winGame) {
    showWinScreen();
  } else {

    if (riverSound != null) {
      riverSound.pause();
      roadSound.pause();
    }

    if (currentScene == -2) { // Start Screen
      showStartScreen();
    } else if (currentScene == -3) { // Settings
      showSettings();
    } else {  // Level Selection
      showLevelSelect();
    }
  }

  textSize(15);
  for (int i=0; i<notifications.size(); i++) {
    notifications.get(i).display();
    notifications.get(i).update();
  }
}


// Keyboard Interaction
void keyPressed() {
  if (!startGame) {
    if (currentScene == -2) { // Start Screen
      startScreenListener();
    } else if (currentScene == -3) { // Settings
      settingsScreenListener();
    } else if (currentScene == -1) {  // Level Selection
      levelSelectionListener();
    }
  }

  if (endGame) {
    if (currentScene == -4) { // Losing
      losingScreenListener();
    }
  }

  if (winGame) {
    winScreenListener();
  }

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
  if (currentScene > -1 && currentScene != sceneAmount && scenes.get(currentScene).frogger != null) {
    Frog frog = scenes.get(currentScene).frogger;
    if (debug || frog.alive() && frog.isNotDying()) {
      if (keyCode == UP) {
        if (frog.ypos >= heightOfRow) {
          score += 0.1;
        }
        frog.moveUp();
      } else if (keyCode == DOWN) {
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

  if (!folder.exists()) {
    File newFolder = new File(sketchPath("logs"));
    newFolder.mkdir();
  }

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