import gifAnimation.*;
import controlP5.*;
import java.util.Collections;

GifMaker gif;

ControlP5 cp5;
ColorPicker colorpicker;

int n,m,N;

PVector[] positions;
PVector[] edges;
float[][] adjM;

float t = 0;
float ns;
float nst;

boolean cycle_color = false;
float offset;
float radius;
float inner_radius;

void setup()
{
  size(500,500);
  
  N = 2000;
  
  positions = new PVector[N];
  edges = new PVector[N];
  
  for(int i = 0; i < N; i++)
  {
    positions[i] = new PVector(0,0);
  }

  initGUI();
}

void draw()
{  
  background(0);

  if(cycle_color)
    stroke(255*0.5*(1+cos(t)),200,200);
  else
    stroke(colorpicker.getColorValue());

  inner_radius  = 0.25*(1+cos(t));
  radius        = 0.5*(1.5+sin(t));
  
  for(int i = 0; i < N; i++)
  {
    float r = width*0.5*inner_radius + width*0.5*radius*noise(ns*i/N,nst*t);
    positions[i].x = width/2  + r*cos(TWO_PI*i/N);
    positions[i].y = height/2 + r*sin(TWO_PI*i/N);
  }
  
  prim();
  
  noFill();
  for(int i = 0; i < N-1; i++)
  {
    line(positions[int(edges[i].x)].x,positions[int(edges[i].x)].y,
         positions[int(edges[i].y)].x,positions[int(edges[i].y)].y);
  }
  
  t += TWO_PI/500;
}

float dist(int i, int j)
{

  return PVector.sub(positions[i],positions[j]).mag();
}

void prim()
{
  // A: list of vertices not yet included in the ST
  ArrayList<Integer> A = new ArrayList<Integer>();
  
  for(int i = 0; i < N; i++) A.add(i);
  
  // cost[i]: the cost of the cheapest connection to vertex i
  float[] cost = new float[N];
  // edge[i]: the edge providing that connection
  int[] edge = new int[N];
  
  // initialize cost[i] = infinity, edge[i] = -1 for all i
  for(int i = 0; i < N; i++)
  {
    cost[i] = Integer.MAX_VALUE;
    edge[i] = -1;
  }
  
  int k = 0;
  // while A is not empty:
  while(A.size() > 0)
  {
    //Collections.shuffle(A);

    // find the vertex in A with the smallest cost
    int argmin = -1;
    for(Integer i : A) if(argmin == -1 || cost[i] < cost[argmin]) argmin = i;
    
    A.remove(new Integer(argmin));
    
    for(Integer i : A)
    {
      //float dist = sqrt(pow(positions[argmin].x-positions[i].x,2)+pow(positions[argmin].y-positions[i].y,2));
      
      //if(abs(positions[argmin].x - positions[i].x) <= width/n && abs(positions[argmin].y - positions[i].y) <= height/m)
      if(dist(argmin,i) < cost[argmin])
      {
        cost[argmin] = dist(argmin,i);
        edge[argmin] = i;
      }
    }
    
    edges[k++] = new PVector(argmin,edge[argmin]);
  }
}

void keyPressed()
{
  gif.finish();
  exit();
}

void initGUI()
{
  cp5 = new ControlP5(this);

  colorpicker = new ColorPicker(cp5, "hacktastic");
  colorpicker
  .setPosition(width-256,0)
  .setColorValue(color(255,150));

  cp5.addButton("Cycle_Color")
  .setValue(0)
  .setPosition(0,0)
  .setSize(120,20)
  ;

  cp5.addSlider("Radius")
  .setValue(0.5)
  .setRange(0,1)
  .setPosition(0,21)
  .setSize(120,20);

  cp5.addSlider("Inner_Radius")
  .setValue(0.3)
  .setRange(0,1)
  .setPosition(0,42)
  .setSize(120,20);

  cp5.addSlider("Noise_Scale")
  .setValue(1000)
  .setRange(0,1000)
  .setPosition(0,63)
  .setSize(120,20);

  cp5.addSlider("Time_Scale")
  .setValue(0.1)
  .setRange(0,1)
  .setPosition(0,84)
  .setSize(120,20);
}

public void Cycle_Color()
{
  cycle_color = !cycle_color;
}

public void Offset(float x)
{
  offset = x;
}

public void Radius(float x)
{
  radius = x;
}

public void Inner_Radius(float x)
{
  inner_radius = x;
}

public void Noise_Scale(float x)
{
  ns = x;
}

public void Time_Scale(float x)
{
  nst = x;
}
