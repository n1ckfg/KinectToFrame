void keyPressed() {
  if (key == ' ') {
    saveFrame("capture/frame_" + zeroPadding(counter, 1000) + ".png");
    if (frameList.size() > frameListMax) frameList.remove(0);
    frameList.add(context.depthImage());
    counter++;
  }
  
  if (key == 'p') {
    isPlaying = !isPlaying;
  }
}