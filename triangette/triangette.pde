
/* class definitions */

/* global variables */

/* t: time */
float t = 0;
/* dt: delta t */
float dt = 0.01;
/* ns: noise scale */
float ns = 0.02;

/* main routines */

void setup()
{
  size(displayWidth,displayHeight);
}

void draw()
{
  background(0);
  translate(width/2,height/2);
  
  int N = 50;
  float R = 200;
  for(int i = 0; i < N; i++)
  {
    float r = R*(N-i)/N;
    
    stroke(50);
    
    if(i%2 == 0)
      fill(0);
    else
      fill(255);
      
    float v = 0.02*(R-r);
    
    rotate(v*t);
    triangle( r*cos(-PI/6), r*sin(-PI/6), r*cos(-PI/6 + 2*PI/3), r*sin(-PI/6 + 2*PI/3), r*cos(-PI/6 + 4*PI/3), r*sin(-PI/6 + 4*PI/3) );
    rotate(-v*t);
  }
  
  t += dt;
}

/* auxiliary routines */
