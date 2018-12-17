void showConnecting() {
  counter++;  // Keep track of how long we've been waiting to connect
  
  //-- Gradient Background --//
  beginShape(POLYGON);
  stroke(0, 200, 150, 80);
  fill(0, 200, 150+sin(frameCount/10.0)*50);
  vertex(0, 0);

  stroke(0, 150, 200, 80);
  fill(0, 150+sin(frameCount/10.0)*50, 200);
  vertex(width, 0);

  stroke(0, 150, 200, 80);
  fill(0, 150+sin(frameCount/10.0)*50, 200);
  vertex(width, height);

  stroke(0, 200, 150, 80);
  fill(0, 200, 150+sin(frameCount/10.0)*50);
  vertex(0, height);
  endShape(CLOSE);
  
  
  //-- Text --//
  fill(255);
  textSize(width/30);
  text("Connecting...", 0, 0, width, height);
  
  
  // Display back button if connection is too slow
  if (counter > 20){
    fill(50, 20);
    noStroke();
    rect(width/2-200, height-250, 400, 100, 10);
    
    fill(255);
    textSize(width/70);
    text("Having trouble connecting.", 0, 100, width, height);
    
    text("Back", width/2, height-200);
    
    if (mousePressed && mouseX > width/2-200 && mouseX < width/2+200 && mouseY > height-250 && mouseY < height-150) {
      scene = 0;
      counter = 0;
      key_input = "";
    }
  }
}