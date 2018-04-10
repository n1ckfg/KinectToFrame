PShader shader_rgba, shader_depth_color, shader_thresh; 
//PImage rgbImg, depthImg;
PGraphics tex;

PVector shaderMousePos = new PVector(0,0);
PVector shaderMouseClick = new PVector(0,0);

void setupShaders() {
  tex = createGraphics(width, height, P2D);

  shader_rgba = loadShader("rgba.glsl"); 
  shader_depth_color = loadShader("depth_color.glsl"); 
  shader_thresh = loadShader("thresh.glsl");
  
  shaderSetSize(shader_rgba);
  shaderSetSize(shader_depth_color);
  shaderSetSize(shader_thresh);
  
  //rgbImg = loadImage("rgb.png");
  //depthImg = loadImage("depth.png");
}

void updateShaders() {
  //shaderSetMouse(shader);
  //shaderSetTime(shader);
  if (drawMode == DrawMode.RGBA) {
    shaderSetTexture(shader_rgba, "tex0", rgbImg);
    shaderSetTexture(shader_rgba, "tex1", depthImg);
  } else if (drawMode == DrawMode.DEPTH_COLOR) {
    shaderSetTexture(shader_depth_color, "tex0", depthImg);
  }
}

//void drawShaders() {
  //filter(shader);
//}

// ~ ~ ~ ~ ~ ~ ~

void shaderSetVar(PShader ps, String name, float val) {
    ps.set(name, val);
}

void shaderSetSize(PShader ps) {
  ps.set("iResolution", float(width), float(height), 1.0);
}

void shaderSetMouse(PShader ps) {
  if (mousePressed) shaderMousePos = new PVector(mouseX, height - mouseY);
  ps.set("iMouse", shaderMousePos.x, shaderMousePos.y, shaderMouseClick.x, shaderMouseClick.y);
}

void shaderSetTime(PShader ps) {
  ps.set("iGlobalTime", float(millis()) / 1000.0);
}

void shaderMousePressed() {
  shaderMouseClick = new PVector(mouseX, height - mouseY);
}

void shaderMouseReleased() {
  shaderMouseClick = new PVector(-shaderMouseClick.x, -shaderMouseClick.y);
}

void shaderSetTexture(PShader ps, String name, PImage tex) {
  ps.set(name, tex);
}
