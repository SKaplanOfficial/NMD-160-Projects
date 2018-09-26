// A class that manages and displays a safezone row in the game Frogger.
class Safezone{
  // Position Attributes
  float ypos;
  
  // Images
  PImage grassImage;
  
  
  // Constructor
  Safezone(float ypos_){
    ypos = ypos_;
  }
  
  
  // Currently unused, but kept for easy access later
  void update(){
  }
  
  
  // Displays this row
  void display(){
    noStroke();
    
    if (grassImage == null) {
      // If no grass image is provided, resort to green rectangles
      fill(100,200,0);
      rect(0, ypos, width, heightOfRow);
    } else {
      // Otherwise, use math to provide optimal tiling of image along the row
      float ratio = grassImage.height/heightOfRow;
      for (int x=0; x<width; x += grassImage.width/ratio) {
        image(grassImage, x, ypos, grassImage.width/ratio, heightOfRow);
      }
    }
  }
  
  
  // Add background image to row (Can be used to have different design for each level)
  void setImage(PImage grassImage_) {
    grassImage = grassImage_;
  }
}