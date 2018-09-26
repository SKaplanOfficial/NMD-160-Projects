class NotificationWrapper {
  float xpos, ypos;
  float targetX, targetY;
  float sizeX, sizeY;
  int timer;
  int timeShown;

  String message;
  int id;

  boolean inList = true;

  color c;

  int frameAtCreation;
  
  NotificationWrapper(String message_, int timer_, int id_, boolean inList_){
    message = message_;
    timer = timer_;
    id = id_;
    inList = inList_;
    
    frameAtCreation = frameCount;
    
    if (inList){
      notificationAmount++;
    }
    
    targetX = 3;
    
    sizeX = 200;
    sizeY = 50;
    
    c = color(20, 100);
  }
  
  void update() {
    float dx = targetX - xpos;
    xpos += dx * 0.1;

    float dy = targetY - ypos;
    ypos += dy * 0.1;
  }

  void display() {
    pushStyle();
    noStroke();
    fill(c);
    rect(xpos, ypos, sizeX, sizeY);

    fill(255);
    textAlign(CENTER, CENTER);
    text(message, xpos, ypos, sizeX, sizeY);
    popStyle();
  }
}

class Notification extends NotificationWrapper {

  Notification(String message_, float targetX_, float targetY_, float sizeX_, float sizeY_, int timer_, int id_, boolean inList_, color c_) {
    super(message_, timer_, id_, inList_);

    targetX = targetX_;
    targetY = targetY_;

    sizeX = sizeX_;
    sizeY = sizeY_;

    if (inList) {
      xpos = -sizeX;
      ypos = height+sizeY;
    } else {
      xpos = targetX;
      ypos = -sizeY;
    }

    c = c_;
  }


  Notification(String message_, float targetX_, float targetY_, float sizeX_, float sizeY_, int timer_, int id_, boolean inList_) {
    super(message_, timer_, id_, inList_);

    targetX = targetX_;
    targetY = targetY_;

    sizeX = sizeX_;
    sizeY = sizeY_;

    if (inList) {
      xpos = -sizeX;
      ypos = height+sizeY;
    } else {
      xpos = targetX;
      ypos = -sizeY;
    }
  }

  Notification(String message_, int timer_, int id_, color c_) {
    super(message_, timer_, id_, true);

    targetY = height-(50+3)*(id+1); 

    xpos = -sizeX;
    ypos = targetY;

    c = c_;
  }

  Notification(String message_, int timer_, int id_){
    super(message_, timer_, id_, true);

    targetY = height-(50+3)*(id+1); 

    xpos = -sizeX;
    ypos = targetY;
  }
  
  void update(){
    super.update();
    
    if (timer == -1 || timeShown < timer) {
      timeShown++;
    } else {
      for (int i=0; i<notifications.size(); i++) {
        if (inList && targetY != height+sizeY && notifications.get(i).frameAtCreation >= frameAtCreation && notifications.get(i).inList) {
          notifications.get(i).id = i;
          notifications.get(i).targetY += sizeY+3;
        }
      }

      if (inList && targetY != height+sizeY && notifications.size() > 0) {
        notificationAmount--;
      }

      targetY = height+sizeY;

      if (ypos > height) {
        notifications.remove(this);
      }
    }
  }
  
  void display(){
    super.display();
  }
}