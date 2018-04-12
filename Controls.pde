PVector lastMousePress = new PVector(0, 0);

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

void mousePressed() {
  if (remapWorld) {
    lastMousePress = new PVector(mouseX, mouseY);
    drawMode = DrawMode.DEPTH_ONLY;
  }
}

void mouseReleased() {
  if (remapWorld) {
    settings.write();
  }
}
