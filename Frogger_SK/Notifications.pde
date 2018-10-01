// A wrapper class for notifications that manages the base functionality of all notifications, regardless of type
class NotificationWrapper {
  // Position Attributes
  float xpos, ypos;
  float targetX, targetY;

  // Size Attributes
  float sizeX, sizeY;

  // Timing Attributes
  int timer;
  int timeShown;
  int frameAtCreation;

  // Customization Attributes
  String message;
  boolean inList = true;
  color c;

  // Utility Attributes
  int id;


  //***WRAPPER CONSTRUCTOR***//

  NotificationWrapper(String message_, int timer_, int id_, boolean inList_) {
    targetX = 3;  // Default values are for base notification type

    sizeX = 200;
    sizeY = 50;

    frameAtCreation = frameCount;
    timer = timer_;

    message = message_;
    inList = inList_;
    c = color(20, 100);


    if (inList) {
      // Increase notification amount if included in list
      notificationAmount++;
    }

    id = id_;
  }


  //***WRAPPER UPDATE METHOD***//

  void update() {
    // Ease into position
    float dx = targetX - xpos;
    xpos += dx * 0.1;

    float dy = targetY - ypos;
    ypos += dy * 0.1;
  }


  //***WRAPPER DISPLAY METHOD***//
  
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


// Notification class with overloaded constructors to allow for different notification types
class Notification extends NotificationWrapper {
  
  //***NOTIFICATION CONSTRUCTOR TYPES***//

  // Color customed notifications
  Notification(String message_, float targetX_, float targetY_, float sizeX_, float sizeY_, int timer_, int id_, boolean inList_, color c_) {
    // Set required properties in wrapper
    super(message_, timer_, id_, inList_);

    // Set optional properties in wrapper
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

    // Set color
    c = c_;
  }


  // Customed notifications
  Notification(String message_, float targetX_, float targetY_, float sizeX_, float sizeY_, int timer_, int id_, boolean inList_) {
    // Set required properties in wrapper
    super(message_, timer_, id_, inList_);

    // Set optional properties in wrapper
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


  // Color basic notification
  Notification(String message_, int timer_, int id_, color c_) {
    // Set required properties in wrapper
    super(message_, timer_, id_, true);

    // Set optional properties in wrapper
    targetY = height-(50+3)*(id+1); 

    xpos = -sizeX;
    ypos = targetY;

    // Set color
    c = c_;
  }


  // Basic notification
  Notification(String message_, int timer_, int id_) {
    // Set required properties in wrapper
    super(message_, timer_, id_, true);

    // Set optional properties in wrapper
    targetY = height-(50+3)*(id+1); 

    xpos = -sizeX;
    ypos = targetY;
  }


  //***NOTIFICATION UPDATE METHOD***//

  // All notifications share this update method as well as the one declared in the wrapper
  void update() {
    super.update();

    if (timer == -1 || timeShown < timer) {  // timer = -1 indicates persistant notification
      // Keep track of how long this notification bas been displayed
      timeShown++;
    } else {
      
      // When it's time to remove this notification, change targetY of other notifications to account for change in line-up
      for (int i=0; i<notifications.size(); i++) {
        if (inList && targetY != height+sizeY && notifications.get(i).frameAtCreation >= frameAtCreation && notifications.get(i).inList) {
          notifications.get(i).id = i;
          notifications.get(i).targetY += sizeY+3;
        }
      }

      // If this notification is set to impact the list, decrease notification amount
      if (inList && targetY != height+sizeY && notifications.size() > 0) {
        notificationAmount--;
      }

      // Move off the screen
      targetY = height+sizeY;

      // Finally, remove this notification
      if (ypos > height) {
        notifications.remove(this);
      }
    }
  }


  //***NOTIFICATION DISPLAY METHOD***//
  
  void display() {
    super.display();
  }
}