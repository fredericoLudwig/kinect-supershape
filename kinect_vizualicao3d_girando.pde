

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

// Kinect Library object
Kinect kinect;

// Angle for rotation
float a = 45;
float offset;
// We'll use a lookup table so that we don't have to repeat the math over and over
float[] depthLookUp = new float[2048];

void setup() {

size(displayWidth, displayHeight, P3D); 

  colorMode(HSB);
  //fullScreen(P3D);
  // Rendering in P3D
 // size(800, 600, P3D);
  kinect = new Kinect(this);
  kinect.initDepth();

  // Lookup table for all possible depth values (0 - 2047)
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
    
  }
}

void draw() {

  background((a+offset)% 256 , 95, 255,250);
offset +=3;
  // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();

  // We're just going to calculate and draw every 4th pixel (equivalent of 160x120)
  int skip = 3;

  // Translate and rotate
  translate(width/2, height/2);
  //rotateY(a);
  
  // Nested for loop that initializes x and y pixels and, for those less than the
  // maximum threshold and at every skiping point, the offset is caculated to map
  // them on a plane instead of just a line
  for (int x = 0; x < kinect.width; x +=skip) {
    for (int y = 0; y < kinect.height; y +=skip) {
      int offset = x + y*kinect.width;

      // Convert kinect data to world xyz coordinate
      int rawDepth = depth[offset];
      PVector v = depthToWorld(x, y, rawDepth);

 
      stroke((rawDepth+ x) % 255 , 205, 255);
      pushMatrix();
      // Scale up by 200
      rotateX(a);
      rotate(a);
      float factor = 200;
      translate(v.x*factor, v.y*factor, factor-v.z*factor);
      // Draw a point
      point(0, 0);
      popMatrix();
    }
 
}
  // Rota}te
  a += 0.015f;
}

// These functions come from: http://graphics.stanford.edu/~mdfisher/Kinect.html
float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}

// Only needed to make sense of the ouput depth values from the kinect
PVector depthToWorld(int x, int y, int depthValue) {

  final double fx_d = 1.0 / 5.9421434211923247e+02;
  final double fy_d = 1.0 / 5.9104053696870778e+02;
  final double cx_d = 3.3930780975300314e+02;
  final double cy_d = 2.4273913761751615e+02;

// Drawing the result vector to give each point its three-dimensional space
  PVector result = new PVector();
  double depth =  depthLookUp[depthValue];//rawDepthToMeters(depthValue);
  result.x = (float)((x - cx_d) * depth * fx_d);
  result.y = (float)((y - cy_d) * depth * fy_d);
  result.z = (float)(depth);
  return result;
}