class RedFlash {

  int tintVal = 255;
  int tintDelta = 20;
  
  RedFlash() {
    //
  }
    
  void run() {
    tint(255, tintVal, tintVal);
    tintVal += tintDelta;
    constrain(tintVal, 0, 255);
  }
  
  void reset() {
    tintVal = 0;
  }
  
}
