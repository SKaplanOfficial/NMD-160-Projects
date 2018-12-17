//*****************************//
//       COLOR SELECTION       //
//*****************************//

// Color pallete to show
float colorFocus;

// Selectable colors
ArrayList<colorOption> colors = new ArrayList<colorOption>();


void showColorInput() {
  // Keep track of how long this scene has been active
  timeToSelect++;


  // Show the background
  renderColorBackground();


  pushMatrix();                // Restrict translations to this block
  pushStyle();                 // Restrict style changes to this block
  textAlign(CENTER, CENTER);   // Center text vertically and horizontally


  // Scene Intent
  textSize(40);
  fill(255);
  text("Click on a color", 0, startY, width, startY*2.5);


  // Scene Data Collection
  textSize(12);
  textAlign(LEFT, TOP);
  text("Information Utilized:\n\t- Color\n\t- Time to select", width-startY*2, height-120, 200, 100);

  popStyle();
  popMatrix();
}



void renderColorBackground() {
  if (!begin) {
    // Find first pallete
    colorFocus = random(80);

    // Add first set of colors
    for (int i=0; i<4; i++) {
      colors.add(new colorOption());
    }


    // Find second pallete
    if (colorFocus > 40) {
      colorFocus = random(30);
    } else {
      colorFocus = random(30, 60);
    }


    // Add second set of colors
    for (int i=0; i<4; i++) {
      colors.add(new colorOption());
    }

    // Do not run this code again
    begin = true;
  } else {
    // Dark theme
    background(0);

    // Display selectable colors
    for (int i=0; i<colors.size(); i++) {
      colors.get(i).run();
    }

    // Listen for mousePress
    colorListener();
  }
}




void colorListener() {
  if (mousePressed) {
    // Detect mouse press in every color option
    for (int i=0; i<colors.size(); i++) {
      int id = colors.get(i).getId();

      if (mouseY > height/8 * id && mouseY < height/8 * (1+id)) {
        // Finalize all user-entered data
        myColor = colors.get(i).getColor();
        finalize();

        // Memory management
        begin = false;
        colors.clear();

        // Reset positioning
        startY = -10;
        targetY = 130;

        // Next Scene (Result)
        scene = 5;
      }
    }
  }
}



class colorOption {
  private color fillColor;
  private int id;

  colorOption() {
    id = colors.size();

    // Set color based on color pallete focus
    if (colorFocus < 10) {
      // RED FOCUS
      fillColor = color(random(100, 255), random(50), random(50));
    } else if (colorFocus < 20) { 
      // GREEN FOCUS
      fillColor = color(random(50), random(100, 255), random(50));
    } else if (colorFocus < 30) {
      // BLUE FOCUS
      fillColor = color(random(50), random(50), random(100, 255));
    } else if (colorFocus < 40) {
      // PURPLE FOCUS
      fillColor = color(random(100, 255), random(50), random(100, 255));
    } else if (colorFocus < 50) {
      // YELLOW FOCUS
      fillColor = color(200, random(100, 200), random(100));
    } else if (colorFocus < 60) {
      // CYAN FOCUS
      fillColor = color(random(50), 200, random(100,200));
    } else if (colorFocus < 70) {
      // WHITE FOCUS
      fillColor =  color(random(180, 200));
    } else if (colorFocus < 80) {
      // BLACK FOCUS
      fillColor = color(random(0, 60));
    }
  }


  void run() {
    // Display the color as a rectangle that spans across the screen
    fill(fillColor);
    noStroke();
    rect(0, height/8 * id, width, height/8);
  }


  //-- Accessors --//

  int getId() {
    return id;
  }

  color getColor() {
    return fillColor;
  }
}