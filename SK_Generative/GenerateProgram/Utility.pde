//*****************************//
//   BUTTONS  AND  TEXTFIELDS  //
//*****************************//

// Time how long user hovers over button
int buttonCounter;

// Used to limit creation of objects upon switching scenes
boolean begin = false;


// Create button listener at specific location
int button(float x, float y, float w, float h, String t) {
  textSize(20);
  if (mouseX > x-w/2 && mouseX < x+w/2 && mouseY > y-h/2 && mouseY < y+h/2) {
    if (mousePressed) {
      // Return 1 when user clicks button
      fill(20);
      stroke(10);
      strokeWeight(5);
      rect(x, y, w, h, 5);

      fill(255);
      text(t, x, y, w, h);

      return 1;
    } else {
      // Return -1 when user doesn't click button, but hovers over the button
      fill(0, 80+buttonCounter, 0, startY);
      stroke(0, 50+buttonCounter, 0, startY);
      strokeWeight(5);
      rect(x, y, w, h, 5);

      fill(255);
      text(t, x, y, w, h);

      if (buttonCounter < 100) {
        buttonCounter++;
      }

      return -1;
    }
  } else {
    // Return 0 when user is not hovering over the button
    fill(80, startY);
    stroke(50, startY);
    strokeWeight(5);
    rect(x, y, w, h, 5);

    fill(255);
    text(t, x, y, w, h);

    if (buttonCounter > 0) {
      buttonCounter--;
    }

    return 0;
  }
}



// Create text field display at specific location
void textBox(float x, float y, float w, float h, String str) {

  int i = 1;
  while ((str.length()*textWidth('a') > width*i)) {
    i++;
  }

  fill(50+str.length(), startY);
  stroke(10, startY);
  strokeWeight(5);

  rect(x, y, w, h*i);

  fill(255);
  text(str, x, y, w, h*i);
}



// Ease various objects into position
void ease() {
  float dy = targetY - startY;
  startY += dy * 0.2;
}



// Keyboard interaction
void keyPressed() {
  if (scene == 1) {
    nameListener();
  } else if (scene == 2) {
    wordListener();
  } else if (scene == 3) {
    numberListener();
  }
}