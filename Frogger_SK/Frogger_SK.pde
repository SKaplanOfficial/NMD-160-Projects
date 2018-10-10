/* Stephen Kaplan - October 1st, 2018 - NMD 160 Frogger Project
 This program is a recreation of Konami's classic "Frogger" game using a modular approach.
 Use the arrow keys to move frogger one "hop" at a time. Avoid colliding with vehicles.
 Direct contact with river water results in immediate loss of one life.
 After 5 lives, the game is over. You may choose to restart at the current level, or go back to the start menu.
 
 Press D to enter debug mode. Once there, press Shift+. to switch to the next scene, or Shift+, to go back to the previous scene.
 In debug mode, press the down arrow to move frogger backward.
 
 Version 1.0c
 */



//*****************************//
//   IMPORTS, VARIABLES, ETC   //
//*****************************//

// IMPORTS
import ddf.minim.*;

// Minim variables
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

int currentScene = -2;      // Level controller
int sceneAmount;            // Set by getFolders()

boolean debug = false;      // Press d to toggle
boolean startGame = false;  // Determines whether to display start menu or not
boolean endGame = false;    // Lose screen
boolean winGame = false;    // Win screen

int currentSelection = 1;   // Selected menu button, change with arrow keys

int sizeSetting = 0;        // 0 = 800x600, 1=800x800, 2=600x600
int soundSetting = 0;       // 0 = On, 1 = Off  -- Eventually load these settings from json file
int musicSetting = 0;       // 0 = On, 1 = Off

// Utility Variables
final String version = "1.0c";
final String divider = new String(new char[5]).replace("", "-");
int notificationAmount;

float heightOfRow;              // Set based on rows defined in each scene's data.json
float performanceModifier = 1;  // More objects loaded => Higher performanceModifier => Lower intensity of some game elements

final String logPath = "logs/"+year()+"/"+month()+"/"+day()+".txt";
boolean doesLogExist;

// Background for Pre_Game menus
final String pathToBg = "data/bgImage.png";
PImage bg;

// Data loaded from json
JSONObject scoreObj;           // Loaded from highscore.json
float score;
float highscore;



//*****************************//
//       SETUP  FUNCTION       //
//*****************************//

// Initializes into start menu
void setup() {
  size(800, 600);              // Size changed in settings menu
  background(21);

  // Instanciate Minim
  minim = new Minim(this);

  // Logging for debugging purposes, see the logs subfolder to see all info
  doesLogExist = getFolders("logs") > 0 ? true: false;
  log("\n"+divider+getExactTime()+divider+"\n");
  log("Initializing Frogger (Version "+version+")");

  // Find scenes & add to array
  log("Loading scenes.");
  sceneAmount = getFolders("Scenes");
  log("Number of scenes found: "+sceneAmount+".");

  for (int i=0; i<sceneAmount; i++) {
    scenes.add(new Scene(scenes.size()));
  }

  // Load data from highscore.json
  scoreObj = loadJSONObject("./data/highscore.json");
  highscore = scoreObj.getFloat("highscore");
}



//*****************************//
//        DRAW FUNCTION        //
//*****************************//

// Runs ~60 times per second, add FPS monitor to debug mode later
void draw() {

  if (startGame && !endGame) {    // Normal gameplay
    textSize(15);
    
    // All objects in scene are managed within scene class
    scenes.get(currentScene).update();
    scenes.get(currentScene).display();

    if (currentScene != sceneAmount) {
      // Frog object to interact with
      Frog frog = scenes.get(currentScene).frogger;
      
      if (frog.deathCount >= frog.maxDeaths && !debug) {    // Lose Screen
        showLoseScreen();
      } else {                                              // Normal Gameplay - Show score & remaining lives
        fill(255);
        textAlign(CENTER, CENTER);
        text("Score: "+round(score)+"\nHigh Score: "+round(highscore), 0, 0, 150, heightOfRow);
        text("Lives: "+(frog.maxDeaths-frog.deathCount), 0, height-heightOfRow, 100, heightOfRow);
      }
    }
    
  } else if (endGame) {          // Lose screen
    showLoseScreen();
    
  } else if (winGame) {          // Win screen
    showWinScreen();
    
  } else {
    if (riverSound != null) {    // Pause gameplay music while in menu
      riverSound.pause();        // Eventually add unique menu music
      roadSound.pause();
    }

    if (currentScene == -2) {        // Start Menu
      showStartScreen();
    } else if (currentScene == -3) { // Settings Menu
      showSettings();
    } else {                         // Level Selection
      showLevelSelect();
    }
  }


  // Display notifications - Independent from scene management
  textSize(15);
  for (int i=0; i<notifications.size(); i++) {
    notifications.get(i).display();
    notifications.get(i).update();
  }
}



//*****************************//
//       KEYBOARD INPUT        //
//*****************************//

// Detects keyboard interaction on menus and during gameplay
void keyPressed() {
  // Navigate menus
  if (!startGame) {
    if (currentScene == -2) {         // Start Screen
      startScreenListener();
    } else if (currentScene == -3) {  // Settings
      settingsScreenListener();
    } else if (currentScene == -1) {  // Level Selection
      levelSelectionListener();
    }
  }

  if (endGame) {                      // Losing
    if (currentScene == -4) { 
      losingScreenListener();
    }
  }

  if (winGame) {                      // Winning
    winScreenListener();
  }


  // Toggle debug mode
  if (key == 'd') {
    // Give notification of state change
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


  // If frog object is active, use arrow key listener (Debug and arrow key listeners can operate concurrently)
  if (currentScene > -1 && currentScene != sceneAmount && scenes.get(currentScene).frogger != null) {
    // Frog object to interact with
    Frog frog = scenes.get(currentScene).frogger;
    
    // Normal gameplay controls, also use these controls is debug mode is on (ignoring death)
    if (debug || frog.alive() && frog.isNotDying()) {
      if (keyCode == UP) {
        // Increase score slightly for succesful vertical advancement across level
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

      // Clear persistant notifications to have user focus on gameplay
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


      // Load next scene
      currentScene += 1;

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


      // Load previous scene
      currentScene -= 1;
      log("Loading Data For Scene "+currentScene);
      scenes.get(currentScene).loadData();

      log("Loading Assets For Scene "+currentScene + " - "+scenes.get(currentScene).getName());
      scenes.get(currentScene).loadAssets();

      addNotification(scenes.get(currentScene).getName()+" - "+scenes.get(currentScene).getCatchPhrase(), 0, height/2-100, width, 200, -1, false);
    }
  }
}



//*****************************//
//         MOUSE INPUT         //
//*****************************//

// Effectively the same listeners are keyPressed(), but we also want to be able to detect mousePress when keys are not pressed
void mousePressed() {
  if (!startGame) {
    if (currentScene == -2) {         // Start Screen
      startScreenListener();
    } else if (currentScene == -3) {  // Settings
      settingsScreenListener();
    } else if (currentScene == -1) {  // Level Selection
      levelSelectionListener();
    }
  }

  if (endGame) {                      // Losing
    if (currentScene == -4) {
      losingScreenListener();
    }
  }

  if (winGame) {                      // Winning
    winScreenListener();
  }
}



//*****************************//
//           UTILITY           //
//*****************************//

// Count items within a directory
// Technically counts all files. This method should only work on UNIX systems (including MacOS).
// Change to better method eventually, but this works for now.
int getFolders(String dir) {
  int folders = 0;  // Count of folders

  java.io.File folder = new java.io.File(sketchPath(dir));

  // Make a log folder if one doesn't already exist
  if (dir == "logs" && !folder.exists()) {
    File newFolder = new File(sketchPath("logs"));
    newFolder.mkdir();
  }

  // Count items in folder
  String[] list = folder.list();
  for (int i=0; i<list.length; i++) {
    if (!list[i].equals(".DS_Store")) {  // Ignore folder attributes file
      folders++;
      if (dir == "Scenes") {             // Additional output for scene discovery
        log("Found scene " + list[i] + ".");
      }
    }
  }

  // Return count of items
  return folders;
}


// Append log messages to log file
void log(String message) {
  // Determine whether log file already exists
  File file = new File(sketchPath(logPath));
  boolean newLogFile = !file.exists();

  // New Data
  String[] newMessage = {message};

  // Old Data
  String[] pastMessages = null;
  if (doesLogExist) {
    pastMessages = loadStrings(logPath);
  }

  // Combined Data
  String[] logMessage;

  // Combine old and new messages into one array
  if (pastMessages == null && doesLogExist == false) {      // Initial Run
    String[] firstLog = {"VERY FIRST RUN OF FROGGER"};
    logMessage = concat(firstLog, newMessage);
    doesLogExist = true;
  } else if (pastMessages == null && newLogFile == true) {  // Runs on different dates (Not initial, but first of that day)
    logMessage = newMessage;
    newLogFile = false;
  } else {
    logMessage = concat(pastMessages, newMessage);          // Subsequent runs during the same day
  }

  // Saving data array, report to console
  saveStrings(logPath, logMessage);
  println(message);
}


// Returns time down to the current second
// Used in logging
String getExactTime() {
  return year()+"/"+month()+"/"+day()+" @ "+hour()+":"+minute()+":"+second();
}