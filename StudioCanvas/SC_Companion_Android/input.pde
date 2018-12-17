void showKeyInput() {
  background(12);

  //-- GRADIENT BACKGROUND --//
  beginShape(POLYGON);
  stroke(0, 150, 200, 80);
  fill(0, 150, 200);
  vertex(100, 100);

  stroke(0, 0, 200, 80);
  fill(0, 0, 200);
  vertex(width-100, 100);

  stroke(0, 0, 200, 80);
  fill(0, 0, 200);
  vertex(width-100, 200);

  stroke(0, 150, 200, 80);
  fill(0, 150, 200);
  vertex(100, 200);
  endShape(CLOSE);


  //-- KEY INPUT DISPLAY GRADIENT BACKGROUND --//
  float startX = width/2-width/20*(key_input.length());
  float endX = width/2+width/20*(key_input.length());

  strokeWeight(20);
  if (key_input.length() > 0) {
    beginShape();
    stroke(0, 200, dist(startX, 0, width/2, 0)/5, 50);    // Gradient changes as more keys are entered
    fill(0, 200, dist(startX, 0, width/2, 0)/5);          // Size of shape increase as more keys are entered
    vertex(startX, 300);


    stroke(0, 200, dist(startX, 0, width/2, 0), 50);
    fill(0, 200, dist(startX, 0, width/2, 0));
    vertex(endX, 300);

    stroke(0, 200, dist(startX, 0, width/2, 0), 50);
    fill(0, 200, dist(startX, 0, width/2, 0));
    vertex(endX, 520);

    stroke(0, 200, dist(startX, 0, width/2, 0)/5, 50);
    fill(0, 200, dist(startX, 0, width/2, 0)/5);
    vertex(startX, 520);

    endShape(CLOSE);
  }


  //-- TEXT --//
  textAlign(CENTER, CENTER);
  textSize(width/25);
  fill(255, 100);
  text("S  T  U  D  I  O    C  A  N  V  A  S", 100, 100, width-200, 90);

  fill(0, 200, 255);
  textSize(width/60);
  text("Companion", width/2, 170, width/2, 30);

  fill(255);
  textSize(width/20);
  for (int i=0; i<key_input.length(); i++) {
    // Text is always centered despite more keys being entered
    text(key_input.charAt(i), width/2+width/10*i-width/20*(key_input.length()-1), 400);
  }
  
  fill(255);
  textSize(width/60);
  text("Tap to connect to client", 100, height-200, width-200, 100);
}

void key_input_listener() {
  if (key == BACKSPACE || keyCode == 67) {
    // Remove last letter from name
    if (key_input.length() > 0) {
      key_input = key_input.substring(0, key_input.length()-1);
    }
  } else if (key == ENTER || keyCode == 66) {
    // Process name input
    key_input = key_input.toUpperCase();
    
    output = key_input+"|ATTACH";
    c.write(output);

    // Next Scene (Connection)
    scene = 1;
  } else if (key_input.length() < 6 && ((key >= 'A' && key <= 'z') || (key >= '0' && key <= '9'))) {
    // Only allow users to enter A-Z, a-z characters
    key_input = key_input + key;
  }
}