// Stephen Kaplan 2018
// NMD 160
// Initial: November 5th, 2018
// Updated: November 19th, 2018

// This program takes input from the user to generate a generative art program. By entering different values, a user
// can change how the end result looks and behaves. Note that some values are cumulative, meaning that the only way 
// to reset them is to fully exit out of the program.


//*****************************//
//   IMPORTS, VARIABLES, ETC   //
//*****************************//

//-- IMPORTS --//
import java.util.Random;                // Random number generation
import ch.bildspur.postfx.builder.*;    // Visual effects
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;
import toxi.geom.*;                     // Vector library
import rita.*;                          // Word processing library

//-- UTILITY --//
Random random = new Random();           // Random number generation

String version = "1.0.1";               // Version of this program (not the generated one)

PFont font;                             // Custom font for start screen
int scene = 0;                          // Controls what input/visual is displayed on screen

int startY = -10;                       // Used for animating text/buttons into position
float targetY = 130;

int notificationAmount = 0;             // Count of notifications currently on screen

//-- GEN. PROGRAM INFO --//
PrintWriter mainFile;                           // All programs have at least one file
String[] classNames = {"Dot", "Interaction"};
int amountOfExtraFiles = classNames.length;     // They can also have extra files (i.e. class files)

//-- LISTS --//
ArrayList<PrintWriter> extraFiles = new ArrayList<PrintWriter>();                  // List of files beyond main file
ArrayList<String> mainProgram = new ArrayList<String>();                           // Code (lines) of main file
ArrayList<ArrayList<String>> classPrograms = new ArrayList<ArrayList<String>>();   // Code (lines) of extra files
ArrayList<Notification> notifications = new ArrayList<Notification>();             // Event feedback



//*****************************//
//            SETUP            //
//*****************************//

void setup() {
  // P3D needed for PostFx
  fullScreen(P3D);

  // Custom font
  font = createFont("Aliment-Bold.ttf", 101);
  textFont(font, 32);

  // First data to be used for generated program
  startTimeString = hour()+":"+minute()+":"+second();
  startTimeNumber = hour()+minute()+second();
}



//*****************************//
//            DRAW             //
//*****************************//

void draw() {

  // Ease content into position - See Utility tab
  ease();

  switch(scene) {
  case 0:
    showStartScreen();
    break;
  case 1:
    showNameInput();
    break;
  case 2:
    showWordInput();
    break;
  case 3:
    showNumberInput();
    break;
  case 4:
    showColorInput();
    break;
  case 5:
    showResult();
    break;
  }

  // More inputs could be added without much difficulty


  // Display notifications - Independent from scene management
  textSize(15);
  for (int i=0; i<notifications.size(); i++) {
    notifications.get(i).display();
    notifications.get(i).update();
  }
}