//String fileName = "test.obj";
//String rgbFilename = "rgb.png";
//String depthFilename = "depth.png";

void exportObj(String fileName, PImage depth, PImage rgb) {
  boolean vertexColors = true;
  boolean saveMtl = true;

  String[] s = split(fileName, ".");
  String fileType = s[s.length-1];
  fileName = "";
  for (int i=0; i<s.length-1; i++) {
    fileName += s[i];
  }
  boolean exportPly = fileType.toLowerCase().equals("ply");
  
  println("Exporting: " + fileName);
  
  depth.loadPixels();
  rgb.loadPixels();
  
  // OBJ FILE WRITE
  ArrayList<String> obj = new ArrayList<String>();
  
  int depthHeight = depth.height;
  int depthWidth = depth.width;
  
  // The obj file header--don't modify unless you know what you're doing.
  if (!exportPly) {
    obj.add("# -----------------");
    obj.add("# Start of obj file");
    obj.add("g depth");
    if (saveMtl) obj.add("mtllib " + fileName + ".mtl");
  } else {
    obj.add("ply");
    obj.add("format ascii 1.0");
    obj.add("comment VCGLIB generated");
    obj.add("element vertex " + (depth.width * depth.height));
    obj.add("property float x");
    obj.add("property float y");
    obj.add("property float z");
    obj.add("property uchar red");
    obj.add("property uchar green");
    obj.add("property uchar blue");
    obj.add("property uchar alpha");
    obj.add("element face 0");
    obj.add("property list uchar int vertex_indices");
    obj.add("end_header");
  }
  
  for (int y = 0; y < depthHeight; y++) { // WRITE VERTICES
    for (int x = 0; x < depthWidth; x++) {
      int loc = y * depthWidth + x;
      PVector r =  reproject(x, y, depth.pixels[loc]);
      color c = rgb.pixels[loc];
      PVector col = getColor(c);
      
      if (!exportPly) {
        if (vertexColors) {
          obj.add("v " + r.x + " " + r.y + " " + r.z + " " + col.x + " " + col.y + " " + col.z);  
        } else {
          obj.add("v " + r.x + " " + r.y + " " + r.z);  
        }
      } else {
        obj.add(r.x + " " + r.y + " " + r.z + " " + int(red(c)) + " " + int(green(c)) + " " + int(blue(c)) + " 255 "); // Trailing space is on purpose.
      }
    }
  }
  
  if (!exportPly) {
    obj.add("\n");
    
    for (int y = 0; y < depthHeight; y++) { // WRITE NORMALS. TODO: CALCULATE NORMALS CORRECTLY
      for (int x = 0; x < depthWidth ; x++) {
        obj.add("vn " + 0.0 + " " + 0.0  + " " + 1.0);
      }
    }
    
    obj.add("\n");
    
    for (int y = 0; y < depthHeight; y++) { // WRITE TEXTURE MAPPING.
      for (int x = 0; x < depthWidth ; x++) {
        obj.add("vt " + float(x)/depthWidth + " " + float(-y)/depthHeight);
      }
    }
    
    obj.add("\n");
    
    obj.add("usemtl rgb");
    for (int y = 0; y < depthHeight -1; y++) {//WRITE FACE INDEXES
      for (int x = 0; x < depthWidth -1 ; x++) {
        int b = y * depthWidth + x ;
        int a = b + 1;
        int c = (y + 1)* depthWidth + x ;
        int d = c + 1 ;
        //if (depth.pixels[a] > 0 && depth.pixels[b] > 0 && depth.pixels[c] > 0) {
        obj.add("f " + toObjFaceIndex(a + 1) + " " + toObjFaceIndex(b + 1) + " " + toObjFaceIndex(c + 1));            
        //}
        //if (depth.pixels[a] > 0 && depth.pixels[d] > 0 && depth.pixels[c] > 0) {
        obj.add("f " + toObjFaceIndex(a + 1) + " " + toObjFaceIndex(c + 1) + " " + toObjFaceIndex(d + 1));
        //}
      }
    }
    
    if (saveMtl) {
      // MTL FILE WRITE
      ArrayList<String> mtl = new ArrayList<String>();
        
      mtl.add("newmtl rgb");
      mtl.add("Ka 1.000000 1.000000 1.000000");
      mtl.add("Kd 1.000000 1.000000 1.000000");
      mtl.add("Ks 0.000000 0.000000 0.000000");
      mtl.add("illum 0");
      mtl.add("map_Kd " + fileName + ".png");
      
      rgb.save(fileName + ".png");
      saveStrings(fileName + ".mtl", mtl.toArray(new String[mtl.size()]));
    }
  }
 
  saveStrings(fileName + "." + fileType, obj.toArray(new String[obj.size()]));

  println("Export finished.");
}

String toObjFaceIndex(int index) {
  return "" + index + "/" + index + "/" + index;
}

PVector reproject(float x, float y, float z) {
  return new PVector(x, -y, z/8000);
}

PVector getColor(color c) {
  return new PVector(red(c)/255.0, green(c)/255.0, blue(c)/255.0);
}
