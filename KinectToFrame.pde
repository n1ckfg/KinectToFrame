DrawMode drawMode;
Settings settings;
ArrayList<PImage> frameList;
RedFlash redFlash;

int counter = 0;
int frameListCounter = 0;
int playbackCounter = 0;
int frameListMax = 12;
float playbackFps = 12.0;
float playbackInterval = 0.0;
int lastMillis = 0;
int lastButtonPress = 0;
boolean isPlaying = false;

PFont font;
int fontSize = 18;
int textDelay = 2000;

void setup() {
  size(640, 480, P2D);
  settings = new Settings("settings.txt");
  frameRate(30);
  frameList = new ArrayList<PImage>();
  setupKinect();
  redFlash = new RedFlash();
  playbackFps = 1.0/playbackFps;
  lastMillis = millis();
  lastButtonPress = millis();
  drawMode = DrawMode.RGBA;
  font = loadFont("Silkscreen-18.vlw");
  textFont(font, fontSize);
  setupShaders();
}

void draw() {
  background(0);
  
  if (mousePressed && remapWorld) {
    maxZ = map(mouseY, 0, height, 0, 8000);
    println ("New max Z: " + maxZ);
  }
  
  if (!isPlaying || frameList.size() < 1) {
    redFlash.run();
    updateKinect();
    updateShaders();
    
    if (drawMode == DrawMode.RGBA) {
      tex.beginDraw();
      tex.filter(shader_rgba);
      tex.endDraw();
    } else if (drawMode == DrawMode.DEPTH_ONLY) {
      tex.beginDraw();
      tex.image(depthImg, 0, 0);
      tex.endDraw();
    } else if (drawMode == DrawMode.RGB_ONLY) {
      tex.beginDraw();
      tex.image(rgbImg, 0, 0);
      tex.endDraw();
    } else if (drawMode == DrawMode.DEPTH_COLOR) {
      tex.beginDraw();
      tex.filter(shader_depth_color);
      tex.endDraw();
    }
    
    image(tex,0,0);
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
  
  if (millis() < lastButtonPress + textDelay) {
    fill(0);
    text(""+drawMode, fontSize, 1.5*fontSize);
    fill(255);
    text(""+drawMode, fontSize - 1, 1.5 * fontSize - 1);
  }
  //println(playbackCounter + " " + frameList.size() + " " + isPlaying);
  if (mousePressed && remapWorld) {
    stroke(255);
    strokeWeight(2);
    line(mouseX, mouseY, lastMousePress.x, lastMousePress.y);
  }
  
  lastMillis = millis();
} 

void doCapture() {
    redFlash.reset();
    if (doInpainting) {
      if (drawMode == DrawMode.DEPTH_COLOR) {
        depthImg = tex.get();
      }
            
      initMask();
      processMask();
    }
    String fileNameRgb = "capture/rgb_" + zeroPadding(counter, 1000) + ".png";
    String fileNameDepth = "capture/depth_" + zeroPadding(counter, 1000) + ".png";
    
    rgbImg.save(fileNameRgb);
    if (doInpainting) {
      targetImg.save(fileNameDepth);
    } else {
      depthImg.save(fileNameDepth);
    }
   
    if (frameList.size() > frameListMax) frameList.remove(0);
    frameList.add(loadImage(fileNameDepth));
    counter++;
}
