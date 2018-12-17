// Second Visual - Mode: 1
// Goal of visual: Show transition from raw data to more abstract representation of data, further user's understanding of music visuals
void show_visual_two(String[] data) {
  noStroke();
  fill(bg, 50);            // Dark, translucent => Fade out content over time
  rect(0,0,width,height);  // Rectangle covers whole screen

  for (int y=0; y<data.length; y++){      // Y-value of rectangle defined by position in data array & height of window
    for (int x=0; x<data.length; x++){    // X-value of rectangle defined by position in data array & width of window
      fill(parseFloat(data[x])*20, 0, parseFloat(data[y])*20);
      rect(x*width/data.length, y*height/data.length, width/data.length, height/data.length);
    }
  }
}