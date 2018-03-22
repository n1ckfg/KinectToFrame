void keyPressed() {
  if (key == ' ') {
    initMask();
    processMask();
    targetImg.save("capture/frame_" + zeroPadding(counter, 1000) + ".png");
    if (frameList.size() > frameListMax) frameList.remove(0);
    frameList.add(context.depthImage());
    counter++;
  }
  
  if (key == 'p') {
    isPlaying = !isPlaying;
  }
}
String zeroPadding(int _val, int _maxVal){
  String q = ""+_maxVal;
  return nf(_val,q.length());
}
