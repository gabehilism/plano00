
float t = 0; // t: time
float L = 500; // L: the length of the largest leaf
float ns = 0.02; // ns: noise scale

void setup()
{
  size(displayWidth,displayHeight);
  colorMode(HSB,1,1,1);
  stroke(0.4,1,1);
  strokeWeight(1);
}

void draw()
{
  background(0, 0, 0);
  translate(width/2,height/2 + 150);
  
  leaf(PI,0.2*L);
  
  // left side first leaf (from bottom to up)
  leaf(2*PI/3, 0.5*L);
  // right side first leaf (from bottom to up)
  leaf(-2*PI/3, 0.5*L);
  
  // left side second leaf (from bottom to up)
  leaf(4*PI/10, 0.8*L);
  // right side second leaf (from bottom to up)
  leaf(-4*PI/10, 0.8*L);
  
  // left side third leaf (from bottom to up)
  leaf(-PI/5, 0.9*L);
  // right side third leaf (from bottom to up)
  leaf(PI/5, 0.9*L);
  
  // top leaf
  leaf(0,L);
  
  t += TWO_PI/200 ;
}

void leaf(float a, float l)
{  
  // c: 
  float c = (1+cos(t))*0.5*abs(a);//min(abs(a),(0.5*t)*abs(a));
  
  // updating a
  if(a == PI)
    a = PI/2 + a;
  else if(a == 0)
    a = PI/2;
  else
    a = PI/2 + (a/abs(a))*c;
  
  // r: leaf's radius at time t
  float r = 0.2*l + (1+cos(t))*0.4*l;//min(l,0.5*l*t);
  
  // color: green (hue: 0.4)
  stroke(0.4,1,1);
  // drawing a line representing the leaf's main vein
  line(0, 0, r*cos(a), -r*sin(a));
  
  for(float i = 0; i < r; i+=(r/100))
  {
    // x0,y0: coordinates of the ith midpoint in the leaf
    float x0 = i*cos(a);
    float y0 = -i*sin(a);
    
    // n: noise modulating the vein's length
    float n = 0.0008*(1 + 0.4*(-0.5 + noise(ns*i)));
    
    // d: angle between the main vein and this vein
    float d = (PI/6);
    // p: the vein's length
    float p = n*(pow(1-0.4,2)*pow(r,2) - pow(i-0.4*r,2));
    
    // the veins' colors change with i
    stroke(0.15 + 0.0005*i, 1, 1);
    // left vein
    line(x0,y0, x0 + p*cos(a + d), y0 - p*sin(a + d));
    // right vein
    line(x0, y0, x0 + p*cos(a - d), y0 - p*sin(a - d));
  }
}
