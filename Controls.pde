void keyPressed() {
  if (key == ' ') {
    doCapture();
  }
  
  if (key == 'p' || key == 'P') {
    isPlaying = !isPlaying;
  }
  
  if (key == 'd' || key == 'D') {
      lastButtonPress = millis();
      drawMode = drawMode.next();    
  }
}
