
//import gifAnimation.*;

//GifMaker gif;

class Particle
{
  float x;
  float y;
  
  float px;
  float py;
  
  float vx;
  float vy;
  
  Particle(float _x, float _y, float _vx, float _vy)
  {
    x = _x;
    y = _y;
    
    vx = _vx;
    vy = _vy;
    
    px = x;
    py = y;
  }
  
  void update()
  {    
    px = x;
    py = y;
    
    x += vx;
    y += vy;
    
    vy += 0.0001*norm(x-cx,y-cy);
    vx *= 1.005;
  }
  
  boolean outside_bounds()
  {
    return ( (x < -width/2) || (x > width/2) || (y < -height/2) || (y > height/2) );
  }
    
  void draw()
  {
    update();
    
    strokeWeight(random(1, 5-5*norm(this.x-cx,this.y-cy)/norm(width/2,height/2) ));
    stroke(216, 129, 25);
    line(x-10*vx, y-10*vy, x, y);
    
    strokeWeight(1);
    stroke(250,20,0);
    line(x-10*vx, y-10*vy, x, y);
  }
}

float x;
float y;

float cx = 0;
float cy = 0;

float t = -10*TWO_PI;
float r;

float ns = 4;

ArrayList<Particle> particles;

float norm(float a, float b)
{
  return sqrt(a*a + b*b);
}

PGraphics pg;

void setup()
{
  pg = createGraphics(500,500);
  
  size(500,500);
  background(100);
  
  particles = new ArrayList<Particle>();

  //gif = new GifMaker(this, "a-8-v2.gif");
  //gif.setRepeat(0); // make it an "endless" animation
  //gif.setQuality(20);
  //gif.setDelay(20);
}

void draw()
{
  strokeWeight(1);
  translate(width/2,height/2);
  
  for(int i = 0; i < 1; i++)
  {
    r = 50;
    float px = x;
    float py = y;
    x = r*cos(t);
    y = r*sin(t);
    
    if(mousePressed)
    {
      x = mouseX-width/2;
      y = mouseY-height/2;
    }
    
    strokeWeight(20);
    stroke(200,50,0);
    point(x,y);
    strokeWeight(1);
    
    float dx = x - px;
    float dy = y - py;
    
    float vx = dx/norm(dx,dy);
    float vy = dy/norm(dx,dy);
    
    Particle p = new Particle(x,y, 5*(-0.25+noise(ns*i,ns*cos(t/2),4321))*vx, 5*(-0.25+noise(ns*i,ns*cos(t/2),1234))*vy );
    particles.add(p);
    
  }
  
  ArrayList<Particle> aux = new ArrayList<Particle>();
  
  for(int j = 0; j < particles.size(); j++)
  {
    Particle q = particles.get(j);
    
    if(!q.outside_bounds())
    {
      aux.add(q);
    }
  }
  
  particles = aux;
  
  for(int j = 0; j < particles.size(); j++)
  {
    particles.get(j).draw();
  }

  noStroke();
  fill(10,10);
  rect(-width/2,-height/2,width,height);

  t += (2*PI)/70;
  /*if(t >= 4*TWO_PI)
  {
    gif.finish();
    exit();
  }
  else if(t >= 0)
  {
    gif.addFrame();
  }*/
}
