ArrayList<PImage> frameList;
int counter = 0;
int frameListCounter = 0;
int playbackCounter = 0;
int frameListMax = 12;
float playbackFps = 12.0;
float playbackInterval = 0.0;
int lastMillis = 0;
boolean isPlaying = false;
RedFlash redFlash;

void setup() {
  size(640, 480, P2D);
  frameList = new ArrayList<PImage>();
  setupKinect();
  redFlash = new RedFlash();
  playbackFps = 1.0/playbackFps;
  lastMillis = millis();
}

void draw() {
  background(0);
  
  if (!isPlaying || frameList.size() < 1) {
    redFlash.run();
    updateKinect();
    //image(rgbImg, 0, 0);
    image(depthImg, 0, 0);
  } else if (isPlaying && frameList.size() > 0) {
    tint(0, 255, 0);
    image(frameList.get(playbackCounter), 0, 0);
    playbackInterval += (float) ((millis() - lastMillis) / 1000.0);
    if (playbackInterval > playbackFps) {
      playbackInterval = 0.0;
      playbackCounter++;
      if (playbackCounter > frameList.size()-1) playbackCounter = 0;
    }
  }
  println(playbackCounter + " " + frameList.size() + " " + isPlaying);
  
  lastMillis = millis();
} 
