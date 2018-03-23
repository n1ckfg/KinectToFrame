void keyPressed() {
  if (key == ' ') {
    redFlash.reset();
    initMask();
    processMask();
    String fileName = "capture/frame_" + zeroPadding(counter, 1000) + ".png";
    targetImg.save(fileName);
    //rgbImg.save(fileName);
    if (frameList.size() > frameListMax) frameList.remove(0);
    frameList.add(loadImage(fileName));
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
