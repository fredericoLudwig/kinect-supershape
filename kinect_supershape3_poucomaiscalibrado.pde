import org.openkinect.freenect.*;
import org.openkinect.processing.*;

// The kinect stuff is happening in another class
KinectTracker tracker;
Kinect kinect;


float s = 100;
float x = random(0.1, -0.1) ;
float n = 0.5;
float xb ;
float xb2;
float y = random(0.1, -0.1) ;
float rx =    0.1 ;
float ry =    0.1 ;
float rz =  random(0.01, -0.01);
float offset;
PVector[][] globe;
int total = 75;

float m = 0;
float mchange = 0;
void setup() {
//fullScreen(P3D);

 //colorMode(HSB);
size(640, 520,P3D);

  kinect = new Kinect(this);
  tracker = new KinectTracker();
//  size(300, 300, P3D);
  globe = new PVector[total+1][total+1];
}
float a = 1;
float b = 1;

float supershape(float theta, float m, float n1, float n2, float n3) {
  float t1 = abs((1/a)*cos(m * theta / 4));
  t1 = pow(t1, n2);
  float t2 = abs((1/b)*sin(m * theta/4));
  t2 = pow(t2, n3);
  float t3 = t1 + t2;
  float r = pow(t3, - 1 / n1);
  return r;
}
void draw() {
  frameRate(8);
  translate(width/2, height/2);
 //frameRate(18);
xb+=0.5;
 // Run the tracking analysis
  tracker.track();
  // Show the image
  tracker.display();
println(mchange);
  // Let's draw the raw location
  PVector v1 = tracker.getPos();
  if(v1.x>=300 && (v1.x < 400)){
  fill(50, 100, 250, 200);
  noStroke();  rotateX(0.000000001);
  //translate(s,s);

   mchange-=0.03; //ellipse(v1.x, v1.y, 20, 20);

  } else if(v1.x<299   && (v1.x >200)){  

     fill(150, 0, 250, 200);
  noStroke(); rotateX(0.000000001);
 // mchange+=0.3;
  //ellipse(v1.x, v1.y, 20, 20);
  }
  else if (v1.x<16   && (v1.x >87.9)){  rotateY(00.00000001);}
  // Let's draw the "lerped" location
  PVector v2 = tracker.getLerpedPos();
  fill(100, 250, 50, 200);
  noStroke();
  ellipse(v2.x, v2.y, 20, 20);
  // Display some info
  int t = tracker.getThreshold();
  fill(0);
  text("threshold: " + t + "    " +  "framerate: " + int(frameRate) + "    " + 
    "UP increase threshold, DOWN decrease threshold", 10, 500);


// Adjust the threshold with key presses



  m = map(sin(mchange), -1, 1, 0, 7);
  //mchange += 0.02;

background(240,xb,mchange%m,100);
  lights();
  
 // rotateZ(random(rz-0.0001,rz+0.0005));
  float r = 200;
  for (int i = 0; i < total+1; i++) {
    float lat = map(i, 0, total, HALF_PI, -HALF_PI);
    float r2 = supershape(lat, mchange, 0.2, 1.7, 1.7);
    //float r2 = supershape(lat, 200, 3, 5, mchange);
    for (int j = 0; j < total+1; j++) {
      float lon = map(j, 0, total, -PI, PI);
      float r1 = supershape(lon, mchange, 0.2, 1.7, 1.7);
     // float r1 = supershape(lon, 100, 2.4, 5,m);
      float x = r * r1 * cos(lon) * r2 * cos(lat);
      float y = r * r1 * sin(lon) * r2 * cos(lat);
      float z = r * r2 * sin(lat);
      globe[i][j] = new PVector(x, y, z);
    }

  }
    offset+=5;
    for (int i = 0; i < total; i++) {
       float hu = noise((n% i)) *255;

        fill(hu,210,230,70);
      for (int j = 0; j < total; j++) {
       float huw = noise((n* j)) *255;
        //noStroke();
        strokeWeight(3);
        stroke(huw,25,250);

      }
         n+=4;

      beginShape(TRIANGLE_STRIP);
      for (int j = 0; j < total+1; j++) {
        PVector v1s = globe[i][j];
        vertex(v1s.x, v1s.y, v1s.z);
        PVector v2s = globe[i+1][j];
        vertex(v2s.x, v2s.y, v2s.z);
      }
      endShape();
      for (x = 0; x<width; x++) {
        float rx=0.03  ;
        rx = rx+0.3;
        float ry =(0.03 );

        ry = ry+0.1;//
        rz= rz+0.01;
      }
  
      

  
  
  }
  
  }