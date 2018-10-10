//*****************************//
//       END GAME SCENES       //
//*****************************//


// Utility Variables
int timer = 0;              // Background fade-in manager
int lastScene = 0;          // To go back to playing level

// Positioning Variables
float post_StartY = 0;      // Initial location of root menu item
float post_TargetY = 0;     // Position to ease toward



//***LOSE SCREEN***//

// Display losing screen
void showLoseScreen() {

  // Set targetY for root menu item
  post_TargetY = height/2;

  // Limit translations, rotations, and styling to this block
  pushStyle();
  pushMatrix();

  // Formatting settings
  textSize(height/30);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);


  // Transition between death and end screen
  if (endGame == true) {
    // Listen for mouse click & key press
    losingScreenListener();


    // Ease toward target
    float dy = post_TargetY - post_StartY;
    post_StartY += dy * 0.2;


    // Fade in text & background image
    if (timer < 255 && timer != 0) {
      timer+=5;
      tint(255, 0, 0, timer*4);
      image(bg, -1, -1, width+1, height+1);

      fill(255, timer-50);
      text("You died more than 5 times.\nWould you like to restart this level?", width/2, post_StartY, width/1.5, height/2);
    } else {


      // Background
      timer = 0;
      tint(255, 0, 0);
      image(bg, -1, -1, width+1, height+1);


      // Death message
      fill(255);
      text("You died more than 5 times.\nWould you like to restart this level?", width/2, post_StartY, width/1.5, height/2);
    }


    // Display buttons/options
    fill(0, 100);
    stroke(0, 50);
    strokeWeight(2);
    rect(width/2, post_StartY, width/1.5, height/4, width/50);

    if (currentSelection == 1) { // YES (PLAY LEVEL AGAIN) SELECTED
      fill(0, 200, 100, 200);
      stroke(0, 255, 100, 150);
      strokeWeight(5);
      rect(width/2-width/5, height-post_StartY+height/5, 200, 50, width/100);

      fill(0, 100);
      stroke(0, 50);
      strokeWeight(2);
      rect(width/2+width/5, height-post_StartY+height/5, 200, 50, width/100);
    } else if (currentSelection == 2) { // NO (BACK TO START MENU) SELECTED
      fill(0, 200, 100, 200);
      stroke(0, 255, 100, 150);
      strokeWeight(5);
      rect(width/2+width/5, height-post_StartY+height/5, 200, 50, width/100);

      fill(0, 100);
      stroke(0, 50);
      strokeWeight(2);

      rect(width/2-width/5, height-post_StartY+height/5, 200, 50, width/100);
    }


    textSize(height/40);
    fill(255);
    text("Yes", width/2-width/5, height-post_StartY+height/5, 200, 50);
    text("No", width/2+width/5, height-post_StartY+height/5, 200, 50);
  } else {
    timer += 1;

    // Unload previous scene
    lastScene = currentScene;
    scenes.get(currentScene).unloadAssets();
    currentScene = -4;

    endGame = true;
  }

  popMatrix();
  popStyle();
}


// Losing screen interaction
void losingScreenListener() {
  if (keyCode == UP || keyCode == LEFT) {
    if (currentSelection > 1) {
      currentSelection--;
    }
  } else if (keyCode == DOWN || keyCode == RIGHT) {
    if (currentSelection < 2) {
      currentSelection++;
    }
  }


  boolean yesButton = mousePressed && mouseX > width/2-width/5-100 && mouseX < width/2-width/5+100 && mouseY > height-post_StartY+height/5-25 && mouseY < height-post_StartY+height/5+25;
  boolean noButton = mousePressed && mouseX > width/2+width/5-100 && mouseX < width/2+width/5+100 && mouseY > height-post_StartY+height/5-25 && mouseY < height-post_StartY+height/5+25;

  if (currentSelection == 1 && keyCode == ENTER || yesButton) { // YES
    post_StartY = 0;
    currentScene = lastScene;
    endGame = false;

    // Load previous scene
    log("Loading Data For Scene "+currentScene);
    scenes.get(currentScene).loadData();

    log("Loading Assets For Scene "+currentScene+" - "+scenes.get(currentScene).getName());
    scenes.get(currentScene).loadAssets();

    addNotification(scenes.get(currentScene).getName()+" - "+scenes.get(currentScene).getCatchPhrase(), 0, height/2-100, width, 200, -1, false);
  } else if (currentSelection == 2 && keyCode == ENTER || noButton) { // NO
    // Reset position variables
    startY = 200;
    targetY = 0;
    post_StartY = 0;


    // Return to start menu
    currentScene = -2;
    currentSelection = 1;

    // Reset state variables
    startGame = false;
    endGame = false;
  }
}



//***WIN SCREEN***//

// Display winning scene
void showWinScreen() {

  // Set targetY for root menu item
  post_TargetY = height/2;

  // Limit translations, rotations, and styling to this block
  pushStyle();
  pushMatrix();

  // Formatting settings
  textSize(height/30);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);


  // Ease toward target
  float dy = post_TargetY - post_StartY;
  post_StartY += dy * 0.2;


  // Fade in text & background image
  if (timer < 255 && timer != 0) {
    timer+=5;
    tint(255, 0, 0, timer-50);
    image(bg, -1, -1, width+1, height+1);

    fill(255, timer-50);
    text("Congratulations!\nYou've won the game.", width/2, post_StartY, width/1.5, height/2);
  } else {

    timer = 0;
    tint(255, 0, 0);
    image(bg, -1, -1, width+1, height+1);

    fill(255);
    text("Congratulations!\nYou've won the game.", width/2, post_StartY, width/1.5, height/2);
  }


  // Text box and clickable button
  fill(0, 100);
  stroke(0, 50);
  strokeWeight(2);
  rect(width/2, post_StartY, width/1.5, height/4, width/50);

  fill(0, 200, 100, 200);
  stroke(0, 255, 100, 150);
  strokeWeight(5);
  rect(width/2, height-post_StartY+height/5, width/1.5, 50);


  textSize(height/40);
  fill(255);
  text("Return to Start", width/2, height-post_StartY+height/5, width/1.5, 50);

  popMatrix();
  popStyle();
}


// Winning screen interaction
void winScreenListener() {
  if (keyCode == ENTER || mousePressed && mouseX > width/2-width/3 && mouseY > height-post_StartY+height/5-25 && mouseX < width/2+width/3 && mouseY < height-post_StartY+height/5+25) {
    // Reset position variables
    startY = 200;
    targetY = 0;
    post_StartY = 0;


    // Return to start menu
    currentScene = -2;
    currentSelection = 1;


    // Reset state variables
    startGame = false;
    endGame = false;
    winGame = false;
  }
}