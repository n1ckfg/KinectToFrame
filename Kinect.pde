boolean mirror = false;
boolean align = true;
boolean multithreaded = true;
boolean remapWorld = false;
PImage depthImg, rgbImg;

// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

/*
// OPENKINECT (MAC / OPENNI / Kinect v1)
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

void setupKinect() {
  depthImg = createImage(640, 480, RGB);
  rgbImg = createImage(640, 480, RGB);
  kinect = new Kinect(this);
  kinect.enableMirror(mirror);
  kinect.initDepth();
  kinect.initVideo();
}

void updateKinect() {
  depthImg = kinect.getDepthImage();
  rgbImg = kinect.getVideoImage();
}
*/

// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
/*
// KINECT4WIN (WIN / MS SDK 1.8 / Kinect v1)
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;

Kinect kinect;

void setupKinect() {
  depthImg = createImage(640, 480, RGB);
  rgbImg = createImage(640, 480, RGB);
  kinect = new Kinect(this);
}

void updateKinect() {
  depthImg = kinect.GetDepth();
  rgbImg = kinect.GetImage();
}
*/
// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

// SIMPLEOPENNI (Kinect v1 and clones, all platforms)
// NOTE: PrimeSense and Asus Xtion clones on Windows + some USB3 chipsets cannot do simultaneous depth and RGB.
// If this affect you, comment out the RGB lines and use depth only.

import SimpleOpenNI.*;

SimpleOpenNI context;
int[] depthValues; // https://clab.concordia.ca/intro-to-kinect-processing/

void setupKinect() {
  depthImg = createImage(640, 480, RGB);
  rgbImg = createImage(640, 480, RGB);
  if (multithreaded) {
    context = new SimpleOpenNI(this,SimpleOpenNI.RUN_MODE_MULTI_THREADED);
  } else {
    context = new SimpleOpenNI(this);
  }
  context.setMirror(mirror);
  context.enableDepth();
  context.enableRGB();
  //context.enableIR();
  if (align) {
    context.alternativeViewPointDepthToImage();
    context.setDepthColorSyncEnabled(true);
  }
}

void updateKinect() {
  context.update();
  if (remapWorld) {
    depthValues = context.depthMap();
    depthImg.loadPixels();
    for (int i=0; i<depthValues.length; i++) {
      depthImg.pixels[i] = depth2intensity(depthValues[i]);
    }
    depthImg.updatePixels();
  } else {
    depthImg = context.depthImage();
  }
  rgbImg = context.rgbImage();
  //rgbImg = context.irImage();
}

// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
