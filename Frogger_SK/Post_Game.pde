int timer = 0;
int lastScene = 0;

float post_StartY = 0;
float post_TargetY = 400;

void showLoseScreen() {

  post_TargetY = height/2;

  pushStyle();
  pushMatrix();

  textSize(height/30);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  if (endGame == true) {

    float dy = post_TargetY - post_StartY;
    post_StartY += dy * 0.2;

    if (timer < 255 && timer != 0) {
      timer+=5;
      tint(255, 0, 0, timer-50);
      image(bg, -1, -1, width+1, height+1);

      fill(255, timer-50);
      text("You died more than 5 times.\nWould you like to restart this level?", width/2, post_StartY, width/1.5, height/2);
    } else {
      if (currentScene > -1) {
        scenes.get(currentScene).unloadAssets();
        lastScene = currentScene;
        currentScene = -4;
      }

      timer = 0;
      tint(255, 0, 0);
      image(bg, -1, -1, width+1, height+1);

      fill(255);
      text("You died more than 5 times.\nWould you like to restart this level?", width/2, post_StartY, width/1.5, height/2);
    }

    fill(0, 100);
    stroke(0, 50);
    strokeWeight(2);
    rect(width/2, post_StartY, width/1.5, height/4, width/50);

    if (currentSelection == 1) {
      fill(0, 200, 100, 200);
      stroke(0, 255, 100, 150);
      strokeWeight(5);
      rect(width/2-width/5, height-post_StartY+height/5, 200, 50, width/100);

      fill(0, 100);
      stroke(0, 50);
      strokeWeight(2);
      rect(width/2+width/5, height-post_StartY+height/5, 200, 50, width/100);
    } else if (currentSelection == 2) {
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
    timer+=5;

    tint(255, 0, 0, timer*255/50);
    image(bg, -1, -1, width+1, height+1);

    //    Frog frog = scenes.get(currentScene).frogger;
    //    frog.opacity -= timer*255/20;

    if (timer > 50) {
      endGame = true;
    }
  }

  popMatrix();
  popStyle();
}

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


  if (currentSelection == 1 && keyCode == ENTER) {
    currentScene = lastScene;
    endGame = false;

    //// Load initial scene (To be changed to start menu later)
    log("Loading Data For Scene "+currentScene);
    scenes.get(currentScene).loadData();

    log("Loading Assets For Scene "+currentScene+" - "+scenes.get(currentScene).getName());
    scenes.get(currentScene).loadAssets();

    addNotification(scenes.get(currentScene).getName()+" - "+scenes.get(currentScene).getCatchPhrase(), 0, height/2-100, width, 200, -1, false);
  } else if (currentSelection == 2 && keyCode == ENTER) {
    startY = 200;
    targetY = 0;

    currentScene = -2;
    currentSelection = 1;
    startGame = false;
    endGame = false;
  }
}




void showWinScreen() {

  post_TargetY = height/2;

  pushStyle();
  pushMatrix();

  textSize(height/30);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  float dy = post_TargetY - post_StartY;
  post_StartY += dy * 0.2;

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

void winScreenListener() {
  if (keyCode == ENTER) {
    startY = 200;
    targetY = 0;

    currentScene = -2;
    currentSelection = 1;

    startGame = false;
    endGame = false;
    winGame = false;
  }
}