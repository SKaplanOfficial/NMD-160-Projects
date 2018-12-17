class User {
  Client me;                         // Client object
  int[] checkedFreqs = new int[50];  // Frequencies to check
  int timer, id;                     // Time to wait before sending more data, id of this client
  String type;                       // Type of client (Tablet or PC)

  User(Client c, int id_, String type_) {
    me = c;
    id = id_;
    timer = 0;
    type = type_;

    // Set checkedFreqs to numbers based on id -> Each client will respond to different set of ids
    for (int i=0; i<checkedFreqs.length; i++) {
      checkedFreqs[i] = i*(10+id*10);
    }
  }

  void update() {
    if (timer > 0) {
      timer--;                     // Decrement timer if needed
    } else if (timer == 0 && isGoing) {
      updateState(packetLimiter);  // Update client
    }
  }

  void updateState(int time) {
    if (!type.equals("Tablet")) {           // Only send data to PC-type clients
      String msg = checkedFreqs.length+"";  // First item in data packet: Length of incoming data
      
      for (int i=0; i<checkedFreqs.length; i++) {
        if (currentSong == 5) {    // Live input
          float val = (in.left.get(checkedFreqs[i])*100 + in.right.get(checkedFreqs[i])*100)/2;  // Value is the ampltiude at checked frequencies averaged between left and right input

          if (val > 0) {
            msg += ", "+val;
          } else {
            msg += ", 0.0";        // Can't just ignore negative numbers as it will cause a mismatch between the data and the specified length
          }
        } else {                   // MP3 input
          msg += ", "+fft.getFreq(checkedFreqs[i]);
        }
      }

      me.write(msg+" \n");         // Send message to client
      messages.add(me+" : "+msg);  // Add to messages array
      timer = time;                // Set delay
    }
  }
}