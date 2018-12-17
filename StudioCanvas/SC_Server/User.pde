//*****************************//
//       USER DEFINITION       //
//*****************************//

public class User {
  Client myClient;
  Client attached;
  String myKey;

  User(Client c, String key_) {
    // Create new user with myClient = c, myKey = key_, attached = null
    myClient = c;
    myKey = key_;
  }
  
  String getKey() {
    return myKey;
  }

  Client getClient() {
    return myClient;
  }
  
  Client getAttached() {
    return attached;
  }
  
  void attach(Client a) {
    attached = a;
  }

  void verifyOnline() {
    if (!myClient.active()) {
    }
  }
}