class Notification {
  float xpos, ypos;
  float targetX, targetY;
  float sizeX, sizeY;
  int timer;
  int timeShown;

  String message;
  int id;

  boolean inList = true;

  Notification(String message_, float targetX_, float targetY_, float sizeX_, float sizeY_, int timer_, int id_, boolean inList_) {
    id = id_;

    inList = inList_;

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

    timer = timer_;

    message = message_;

    if (inList) {
      notificationAmount++;
    }
  }

  Notification(String message_, int timer_, int id_) {
    id = id_;

    targetX = 3;

    targetY = height-(50+3)*(id+1); 

    sizeX = 200;
    sizeY = 50;

    xpos = -sizeX;
    ypos = height+sizeY;

    timer = timer_;

    message = message_;

    notificationAmount++;
  }

  void update() {
    float dx = targetX - xpos;
    xpos += dx * 0.1;

    float dy = targetY - ypos;
    ypos += dy * 0.1;

    if (timer == -1 || timeShown < timer) {
        timeShown++;
    } else {
      for (int i=0; i<notifications.size(); i++) {
        if (inList && targetY != height+sizeY && notifications.get(i).id > id && notifications.get(i).inList) {
          notifications.get(i).id--;
          notifications.get(i).targetY += sizeY+3;
        }
      }

      if (inList && targetY != height+sizeY) {
        notificationAmount--;
      }

      targetY = height+sizeY;

      if (ypos == targetY) {
        notifications.remove(this);
      }
    }
  }

  void display() {
    pushStyle();
    noStroke();
    fill(20, 100);
    rect(xpos, ypos, sizeX, sizeY);

    fill(255);
    textAlign(CENTER, CENTER);
    text(message, xpos, ypos, sizeX, sizeY);
    popStyle();
  }
}