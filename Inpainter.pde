import gab.opencv.*;
import org.opencv.photo.Photo;
import org.opencv.imgproc.Imgproc;
//import processing.opengl.PGraphics2D;

int threshold = 5;
boolean flipVertical = false;
//PGraphics2D canvas;
PGraphics canvas;
OpenCV opencv, mask;
PImage img;
PGraphics targetImg;

void initMask() {
  img = depthImg;
  targetImg = createGraphics(img.width, img.height, P2D);
  opencv = new OpenCV(this, img, true);
  //canvas = (PGraphics2D) createGraphics(img.width, img.height, P2D);
  canvas = createGraphics(img.width, img.height, P2D);
  mask = new OpenCV(this, canvas.width, canvas.height);
  canvas.beginDraw();
  canvas.background(0);
  canvas.endDraw();
}

void processMask() {
  canvas.beginDraw();
  img.loadPixels();
  canvas.loadPixels();
  for (int i=0; i<canvas.pixels.length; i++) {
    if (red(img.pixels[i]) <= threshold) {
      canvas.pixels[i] = color(255);
    } else {
      canvas.pixels[i] = color(0);
    }
  }  
  canvas.updatePixels();
  canvas.endDraw();
 
  mask.loadImage(canvas);
  Imgproc.cvtColor(opencv.getColor(), opencv.getColor(), Imgproc.COLOR_BGRA2BGR);
  Photo.inpaint(opencv.getColor(), mask.getGray(), opencv.getColor(), 5.0, Photo.INPAINT_NS);
  Imgproc.cvtColor(opencv.getColor(), opencv.getColor(), Imgproc.COLOR_BGR2BGRA);

  targetImg.beginDraw();
  targetImg.image(opencv.getOutput(),0,0);
  targetImg.endDraw();
}

void drawInpaintedImg() {
  //
}
