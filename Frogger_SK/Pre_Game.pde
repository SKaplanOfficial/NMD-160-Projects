float startY = 200;
float targetY = 0;

// UI
void showStartScreen() {
  bg = loadImage(pathToBg);
  image(bg, 0, 0, width, height);

  pushStyle();
  rectMode(CENTER);

  float dy = targetY - startY;
  startY += dy * 0.2;

  if (currentSelection == 1) {
    fill(0, 200, 100, 200);
    stroke(0, 255, 100, 150);
    strokeWeight(5);
    rect(width/2, height/2-height/5+startY, width/2, height/6, width/100);

    fill(0, 100);
    stroke(0, 50);
    strokeWeight(2);
    rect(width/2, height/2+startY, width/2, height/6, width/100);
    rect(width/2, height/2+height/5+startY, width/2, height/6, width/100);
  } else if (currentSelection == 2) {
    fill(0, 200, 100, 200);
    stroke(0, 255, 100, 150);
    strokeWeight(5);
    rect(width/2, height/2+startY, width/2, height/6, width/100);

    fill(0, 100);
    stroke(0, 50);
    strokeWeight(2);
    rect(width/2, height/2-height/5+startY, width/2, height/6, width/100);
    rect(width/2, height/2+height/5+startY, width/2, height/6, width/100);
  } else if (currentSelection == 3) {
    fill(0, 200, 100, 200);
    stroke(0, 255, 100, 150);
    strokeWeight(5);
    rect(width/2, height/2+height/5+startY, width/2, height/6, width/100);

    fill(0, 100);
    stroke(0, 50);
    strokeWeight(2);
    rect(width/2, height/2-height/5+startY, width/2, height/6, width/100);
    rect(width/2, height/2+startY, width/2, height/6, width/100);
  }

  fill(255);
  textAlign(CENTER, CENTER);

  textSize(height/10);
  text("Frogger", width/2, 50-startY, width/2, height/6);

  textSize(height/20);
  text("Select Level", width/2, height/2-height/5+startY, width/2, height/6);
  text("Settings", width/2, height/2+startY, width/2, height/6);
  text("Exit Game", width/2, height/2+height/5+startY, width/2, height/6);
  
  textSize(height/40);
  text("Version "+version, width/2, height-50+startY*5, width/2, height/6);
  popStyle();
}

void showLevelSelect() {

  float dy = targetY - startY;
  startY += dy * 0.2;

  pushStyle();
  tint(0, 100, 200, 220);
  image(bg, 0, 0, width, height);

  textAlign(CENTER, CENTER);
  textSize(height/30);

  for (int i=0; i<scenes.size(); i++) {
    String levelInfo = scenes.get(i).loadPreGameData();
    rectMode(CENTER);

    if (currentSelection-1 == i) {
      fill(0, 200, 100, 200);
      stroke(0, 255, 100, 150);
      strokeWeight(5);

      if (startY+i*60 > height-100) {
        targetY -= 60;
      } else if (startY+i*60 < 100) {
        targetY += 20;
      }
    } else {
      fill(0, 100);
      stroke(0, 50);
      strokeWeight(2);
    }

    rect(width/2, startY+i*60, width/2, 50, width/100);

    fill(255);
    text(levelInfo, width/2, startY+i*60, width/2, 50);
  }

  if (currentSelection == scenes.size()+1) {
    fill(0, 200, 100, 200);
    stroke(0, 255, 100, 150);
    strokeWeight(5);
  } else {
    fill(0, 100);
    stroke(0, 50);
    strokeWeight(2);
  }

  rect(width/2, startY+(scenes.size()+1)*60, width/2, 50, width/100);
  fill(255);
  text("Back to Start", width/2, startY+(scenes.size()+1)*60, width/2, 50);

  popStyle();
}

void showSettings() {

  float dy = targetY - startY;
  startY += dy * 0.2;

  pushStyle();
  image(bg, 0, 0, width, height);

  textAlign(TOP, LEFT);


  fill(255);
  textSize(30);
  text("Game Settings", 50, 50-startY, width, 100);

  pushMatrix();
  translate(0, startY);

  textSize(20);
  text("Window Size", 50, 150, width, 200);

  text("Sounds", 50, 250, width, 300);

  if (currentSelection == 1) {
    fill(0, 200, 100, 200);
    stroke(0, 255, 100, 150);
    strokeWeight(5);
    rect(50, 185, 200, 50, width/100); // Screen Size

    fill(0, 100);
    stroke(0, 50);
    strokeWeight(2);
    rect(50, 285, 200, 50, width/100); // Sound
    rect(50, 350, 200, 50, width/100); // Volume
    rect(50, 500, 200, 50, width/100); // Back
  } else if (currentSelection == 2) {
    fill(0, 200, 100, 200);
    stroke(0, 255, 100, 150);
    strokeWeight(5);
    rect(50, 285, 200, 50, width/100); // Sound

    fill(0, 100);
    stroke(0, 50);
    strokeWeight(2);
    rect(50, 185, 200, 50, width/100); // Screen Size
    rect(50, 350, 200, 50, width/100); // Volume
    rect(50, 500, 200, 50, width/100); // Back
  } else if (currentSelection == 3) {
    fill(0, 200, 100, 200);
    stroke(0, 255, 100, 150);
    strokeWeight(5);
    rect(50, 350, 200, 50, width/100); // Volume

    fill(0, 100);
    stroke(0, 50);
    strokeWeight(2);
    rect(50, 185, 200, 50, width/100); // Screen Size
    rect(50, 285, 200, 50, width/100); // Sound
    rect(50, 500, 200, 50, width/100); // Back
  } else if (currentSelection == 4) {
    fill(0, 200, 100, 200);
    stroke(0, 255, 100, 150);
    strokeWeight(5);
    rect(50, 500, 200, 50, width/100); // Back

    fill(0, 100);
    stroke(0, 50);
    strokeWeight(2);
    rect(50, 185, 200, 50, width/100); // Screen Size
    rect(50, 285, 200, 50, width/100); // Sound
    rect(50, 350, 200, 50, width/100); // Volume
  }

  textAlign(CENTER, CENTER);


  fill(255);
  if (sizeSetting == 0) {
    text("800 x 600", 50, 185, 200, 50);
  } else if (sizeSetting == 1) {
    text("800 x 800", 50, 185, 200, 50);
  } else if (sizeSetting == 2) {
    text("500 x 500", 50, 185, 200, 50);
  }

  if (soundSetting == 0) {
    text("On", 50, 285, 200, 50);
  } else if (soundSetting == 1) {
    text("Off", 50, 285, 200, 50);
  }

  if (musicSetting == 0) {
    text("Music On", 50, 350, 200, 50);
  } else if (musicSetting == 1) {
    text("Music Off", 50, 350, 200, 50);
  }

  text("Back to Start", 50, 500, 200, 50);


  popMatrix();
  popStyle();
}


// Listeners
void startScreenListener() {
  if (keyCode == UP || keyCode == LEFT) {
    if (currentSelection > 1) {
      currentSelection--;
    }
  } else if (keyCode == DOWN || keyCode == RIGHT) {
    if (currentSelection < 3) {
      currentSelection++;
    }
  }

  if (currentSelection == 1 && keyCode == ENTER) {
    startY = 400;
    targetY = 200;

    currentSelection = 1;
    currentScene = -1;
  } else if (currentSelection == 2 && keyCode == ENTER) {
    startY = 200;
    targetY = 0;

    currentScene = -3;
    currentSelection = 1;
  } else if (currentSelection == 3 && keyCode == ENTER) {
    exit();
  }
}

void levelSelectionListener() {
  if (keyCode == UP || keyCode == LEFT) {
    if (currentSelection > 1) {
      currentSelection--;
    }
  } else if (keyCode == DOWN || keyCode == RIGHT) {
    if (currentSelection < scenes.size()+1) {
      currentSelection++;
    }
  }

  if (currentSelection == scenes.size()+1 && keyCode == ENTER) {
    startY = 200;
    targetY = 0;

    currentSelection = 1;
    currentScene = -2;
  } else if (keyCode == ENTER) {
    startGame = true;
    currentScene = currentSelection-1;
    currentSelection = 1;

    //// Load initial scene (To be changed to start menu later)
    log("Loading Data For Scene "+currentScene);
    scenes.get(currentScene).loadData();

    log("Loading Assets For Scene "+currentScene+" - "+scenes.get(currentScene).getName());
    scenes.get(currentScene).loadAssets();

    addNotification(scenes.get(currentScene).getName()+" - "+scenes.get(currentScene).getCatchPhrase(), 0, height/2-100, width, 200, -1, false);
  }
}

void settingsScreenListener() {
  if (keyCode == UP || keyCode == LEFT) {
    if (currentSelection > 1) {
      currentSelection--;
    }
  } else if (keyCode == DOWN || keyCode == RIGHT) {
    if (currentSelection < 4) {
      currentSelection++;
    }
  }

  if (keyCode == ENTER) {
    if (currentSelection == 1) {
      sizeSetting = (sizeSetting+1)%3;
      if (sizeSetting == 0) {
        surface.setSize(800, 600);
      } else if (sizeSetting == 1) {
        surface.setSize(800, 800);
      } else if (sizeSetting == 2) {
        surface.setSize(600, 600);
      }
    } else if (currentSelection == 2) {
      soundSetting = (soundSetting+1)%2;
    } else if (currentSelection == 3) {
      musicSetting = (musicSetting+1)%2;
    } else if (currentSelection == 4) {
      startY = 200;
      targetY = 0;

      currentSelection = 1;
      currentScene = -2;
    }
  }
}