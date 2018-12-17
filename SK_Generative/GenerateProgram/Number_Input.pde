//*****************************//
//        NUMBER  ENTRY        //
//*****************************//


void showNumberInput() {
  // Show background
  renderNumberBackground();

  pushMatrix();                // Restrict translations to this block
  pushStyle();                 // Restrict style changes to this block
  textAlign(CENTER, CENTER);   // Center text vertically and horizontally

  // Scene Intent
  translate(0, 0, 1);
  textSize(40);
  fill(255);
  text("Enter a 3-digit number", 0, startY, width, startY*2.5);

  // Scene Input
  textSize(40);
  textBox(0, height-startY*4, width, 100, myNumber);

  // Scene Data Collection
  textSize(12);
  textAlign(LEFT, TOP);
  text("Information Utilized:\n\t- Number\n\t- Parity", width-startY*2, height-120, 200, 100);

  popStyle();
  popMatrix();
}



void numberListener() {
  if (mouseX < width/2) {
    // Only allow number entry when user's mouse is on right side
    addNotification("Check your pointer!", 150);
  } else if (key == BACKSPACE) {
    // Remove last number
    if (myNumber.length() > 0) {
      myNumber = myNumber.substring(0, myNumber.length()-1);
    }
  } else if (myNumber.length() == 3 && key == ENTER) {
    // Reset positioning
    startY = -10;
    targetY = 130;
    
    // Next Scene (Color Input)
    scene = 4;
  } else if (myNumber.length() < 3 && key >= '0' && key <= '9') {
    // Only allow users to enter characters 0-9
    myNumber = myNumber + key;
  }
}



void renderNumberBackground() {
  // Dark theme
  background(25);


  // Display squares
  noStroke();
  for (int x = 0; x <= width; x += width/70) {
    for (int y = 0; y <= height; y += height/60) {
      float n = noise(x * 0.005, y * 0.005, frameCount/50.0);
      
      // Color based on mouse position and noise
      fill(0, y*n/1.5, mouseX/5+x*n/2);
      
      // Show rectangle
      pushMatrix();
      translate(x, y);
      rect(0, 0, 20, 20);
      popMatrix();
    }
  }


  // Add effect filter
  fx.render()
    .bloom(.9, 50, 10)
    .compose();
}