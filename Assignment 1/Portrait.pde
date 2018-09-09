/* Stephen Kaplan - September 10th, 2018 - NMD 160 Assignment #1
 This program produces a pixel art portrait of myself. Press left mouse button after running to get started.
 Change hair color by right-clicking anywhere in the window. Portrait background changes according to mouse position.
 Version 1.0
*/


//*****************************//
//   IMPORTS, VARIABLES, ETC   //
//*****************************//

// IMPORTS
import processing.sound.*;

// Declare the processing sound variables 
SoundFile soundfile;

// Regulators
boolean start = false;

int currentXAmount;
int currentYAmount;

int currentWidth = 750;

int sideLength = 32;
int tileSize = 20;

int hairColor = color(66, 244, 215);

// Dynamic array of square objects that make up face image
ArrayList<Square> squares = new ArrayList<Square>();

// Array of values that correspond to specific fill colors, akin to a "paint by number" kit
// Future versions could read this array from a file, thereby making a custom image viewer
int[] portrait = {
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 6, 2, 2, 2, 2, 1, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 6, 6, 4, 6, 2, 2, 2, 1, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 1, 2, 2, 2, 2, 6, 6, 6, 6, 2, 2, 2, 6, 4, 4, 4, 4, 6, 2, 2, 1, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 1, 2, 2, 6, 6, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 6, 2, 2, 1, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 1, 2, 2, 6, 4, 4, 5, 5, 5, 4, 4, 4, 4, 4, 5, 5, 5, 4, 4, 4, 2, 2, 1, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 1, 2, 3, 4, 4, 1, 1, 1, 1, 5, 4, 4, 4, 5, 1, 1, 1, 1, 4, 4, 6, 3, 1, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 1, 3, 4, 4, 4, 4, 4, 4, 1, 4, 4, 4, 1, 4, 4, 4, 4, 4, 4, 3, 1, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 1, 3, 4, 4, 4, 1, 1, 1, 4, 4, 4, 4, 4, 1, 1, 1, 4, 4, 4, 3, 1, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 1, 3, 4, 4, 4, 4, 1, 1, 4, 4, 4, 4, 4, 1, 1, 4, 4, 5, 4, 3, 1, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 1, 3, 4, 5, 4, 4, 4, 4, 4, 1, 4, 4, 4, 4, 4, 4, 5, 4, 3, 1, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 1, 3, 4, 4, 5, 4, 4, 4, 4, 1, 4, 4, 4, 4, 4, 5, 4, 4, 3, 1, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 1, 3, 4, 4, 5, 4, 4, 4, 1, 5, 4, 4, 4, 4, 4, 5, 4, 3, 1, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 1, 3, 4, 4, 4, 4, 4, 4, 1, 5, 4, 4, 4, 4, 4, 4, 4, 3, 1, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 1, 3, 4, 4, 4, 4, 4, 4, 1, 5, 5, 4, 4, 4, 4, 4, 4, 3, 1, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 1, 3, 4, 4, 4, 4, 4, 4, 1, 1, 4, 4, 4, 4, 4, 4, 3, 1, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 1, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 1, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 4, 4, 4, 4, 4, 4, 4, 4, 1, 4, 4, 4, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 4, 4, 4, 1, 1, 1, 1, 1, 4, 4, 4, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 4, 4, 3, 5, 5, 5, 4, 4, 4, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 4, 4, 3, 3, 3, 4, 3, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 3, 4, 4, 4, 3, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 3, 3, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
};



//*****************************//
//  SETUP AND DRAW FUNCTIONS   //
//*****************************//

// Runs once upon execution. Pop.mp3 located in data subfolder.
void setup() {
  size(750, 750);
  surface.setResizable(true);
  soundfile = new SoundFile(this, "Pop.mp3");
}


void draw() {
  background(51);

  if (!start) { // Show splash screen before interaction begins
    textAlign(CENTER, CENTER);
    textSize(15);
    fill(150);
    text("\"Portrait\"\nBy Stephen Kaplan\nSeptember 2018\n\nPress the left mouse button to get started.", 0, 0, width, height);
  } else if (frameCount%8 == 0 && mousePressed) { // Some form of rate limiting is necessary to avoid audio problems
    for (int i=0; i<8; i++) { // 8 squares added every 5 frames while left mouse button is pressed
    
      if (currentYAmount < sideLength) {
        if (currentXAmount < sideLength) {
          playSound(portrait[currentXAmount + currentYAmount * sideLength]);
          
          // Square(x, y, targetX, targetY, valAtPosition)
          squares.add(new Square(mouseX, mouseY, currentXAmount*tileSize, currentYAmount*tileSize, portrait[currentXAmount + currentYAmount * sideLength]));
          currentXAmount++;
        } else {
          currentXAmount = 0;
          currentYAmount++;
        }
      }
      
    }
  }


  // Go through array of squares and run display method for each
  for (int i=0; i<squares.size(); i++) {
    squares.get(i).display();
  }
} // End of draw()



//*****************************//
//         INTERACTION         //
//*****************************//

// Plays a sound according to value in potrait[]
void playSound(int valAtPosition) {
  if (valAtPosition == 0) {
    soundfile.amp(0.0);                         // Background squares = no sound
  } else if (valAtPosition == 1) {
    soundfile.rate(.5);                         // Black squares = low pitch
    soundfile.amp(0.001);
  } else if (valAtPosition == 2) {
    soundfile.rate(1);                          // Hair squares = high pitch
    soundfile.amp(0.001);
  } else {
    soundfile.rate(0.4+noise(frameCount)/10);   // Other = medium pitch w/ noise
    soundfile.amp(0.001);
  }

  soundfile.play();
}


void mousePressed() {
  if (mouseButton == RIGHT) { // When user presses right mouse button, generate a random hair color
    int rr = int(random(256));
    int rg = int(random(256));
    int rb = int(random(256));

    hairColor = color(rr, rg, rb);
  }

  if (!start) {
    start = !start;
  }
}
