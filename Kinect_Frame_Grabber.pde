ArrayList<PImage> frameList;
int counter = 0;
int frameListCounter = 0;
int playbackCounter = 0;
int frameListMax = 12;
boolean isPlaying = false;

void setup() {
  size(640, 480, P2D);
  frameList = new ArrayList<PImage>();
  setupKinect();
}

void draw() {
  background(0);
  
  if (!isPlaying || frameList.size() < 1) {
    noTint();
    updateKinect();
    image(rgbImg, 0, 0);
    image(depthImg, 100, 0);
  } else if (isPlaying && frameList.size() > 0) {
    tint(0, 255, 0);
    image(frameList.get(0), 0, 0);
    playbackCounter++;
    if (playbackCounter > frameList.size()-1) playbackCounter = 0;
  }
  println(playbackCounter + " " + frameList.size() + " " + isPlaying);
} 
