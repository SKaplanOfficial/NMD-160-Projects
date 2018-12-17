//*****************************//
//         NAME  ENTRY         //
//*****************************//

// Background noise
float xstart = random(10);
float xnoise = 0;
float ynoise = random(10); 

// Effects
PostFX fx;


void showNameInput() {
  if (!begin) {
    // Initialize PostFX
    fx = new PostFX(this);

    // Do not run this code again
    begin = true;
  } else {


    // Dots array background
    renderNameBackground();


    pushMatrix();                // Restrict translations to this block
    pushStyle();                 // Restrict style changes to this block
    textAlign(CENTER, CENTER);   // Center text vertically and horizontally


    // Scene Intent
    textSize(40);
    fill(255);
    text("Enter your first name", 0, startY, width, startY*2.5);


    // Scene Input
    textBox(0, height-startY*4, width, 100, name);


    // Scene Data Collection
    textSize(12);
    textAlign(LEFT, TOP);
    text("Information Utilized:\n\t- Name\n\t- Name Length\n\t- Name Root", width-startY*2, height-120, 200, 100);

    popStyle();
    popMatrix();
  }
}


// Detect keyboard interaction
void nameListener() {
  if (key == BACKSPACE) {
    // Remove last letter from name
    if (name.length() > 0) {
      name = name.substring(0, name.length()-1);
    }
  } else if (key == ENTER) {
    // Process name input
    name = name.toLowerCase();

    // Memory Management
    begin = false;

    // Reset Positioning
    startY = -10;
    targetY = 130;

    // Next Scene (Word Input)
    scene = 2;
  } else if (key >= '0' && key <= '9') {
    // Give message when a user tries to add numbers to their name
    addNotification("Numbers in a name? Too fancy.", 150);
  } else if (key >= 'A' && key <= 'z' && textWidth(name+key) < width) {
    // Only allow users to enter A-Z, a-z characters
    name = name + key;
  }
}


void renderNameBackground() {
  // Dark theme
  background(25);

  smooth();
  ynoise = frameCount/50.0;
  xnoise = -frameCount/40.0; 

  
  // Draw points with noise
  for (int y=-5; y<=height; y+=5) {
    ynoise += 0.05;
    for (int x=-5; x<=width; x+=5) {
      xnoise += 0.05;
      drawNamePoint(x, y, noise(xnoise, ynoise));
    }
  }
  

  // Add effect filter
  fx.render()
    .sobel()
    .bloom(.9, 50, 10)
    .compose();
}



void drawNamePoint(float x, float y, float noiseFactor) {
  // Length based on noise
  float len = 25 * noiseFactor;
  
  // Fill based on distance
  noFill();
  noStroke();
  fill(dist(x, 0, 0, 0)/4, 0, dist(x, 0, width, 0)/2, 150);
  
  // Draw rectangle
  rect(x, y, len, len);
}