// First Visual - Mode: 0
// Goal of visual: Visualize data received in very direct way, "ease" user into understanding how the program works
void show_visual_one(String[] data) {
  background(bg);
  
  for (int x=0; x<data.length; x++){        // For each data input
    strokeWeight(5);                        // Lines of equal thickness
    stroke(parseFloat(data[x])*20, 0, 80);  // Stroke becomes more red as data input at x increases (As the amplitude at the frequency corresponding to that input increases)
    
    // Line from bottom of screen to length according to data input at x
    line(width/data.length * (x+0.5), height, width/data.length * (x+0.5), height-parseFloat(data[x])*10);
  }
}