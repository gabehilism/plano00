
/* class definitions */

/* global variables */

/* t: time */
float t = 0;
/* dt: delta t */
float dt = 0.01;
/* ns: noise scale */
float ns = 0.02;
/* rotx, roty: rotation angles */
float rotx;
float roty;
/* s: scale factor */
float s;

/* main routines */

void setup()
{
  size(600,600,P3D);
  background(0);
  
  rotx = 0;
  roty = 0;
  s = 1;
}

void draw()
{
  background(50);
  
  translate(width/2,height/2);
  
  scale(s);
  rotateX(roty);
  rotateY(rotx + 0.0001*millis());
  
  int N = 120;
  float R = 80;
  for(int i = 0; i < N; i++)
  {
    float r = -R*log(float(N-i)/N);
    
    //strokeWeight(0.005*r);
    stroke(255);
      
    noFill();
      
    float v = 1*exp(float(N-i)/N);
    
    rotateX(v*t);
    rotateY(v*t);
      point(-r,-r);
      point(-r,r);
      point(r,-r);
      point(r,r);
    rotateY(-v*t);
    rotateX(-v*t);
    
  }
  
  t += dt;
}

void mouseDragged()
{
  rotx += (mouseX - pmouseX) * 0.01 / pow(s, 2);
  roty -= (mouseY - pmouseY) * 0.01 / pow(s, 2);
}

void mouseWheel(MouseEvent e)
{
  s -= e.getAmount() / 10;
}

/* auxiliary routines */
