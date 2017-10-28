import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class rorschach extends PApplet {




ControlP5 cp5;

int N = 100;
int V = 100;
float R0 = 0.25f;
float R1 = 0.25f;
float ns = 0.5f;
float nst;

float t = 0;

int seed = 0;

public void setup()
{
  //size(500,500);
  size(displayWidth,displayHeight);
  noStroke();
  initGUI();
}

public void draw()
{
  background(200);

  fill(0);

  randomSeed(seed);
  blob(width/2,height/2);
  for(int i = 0; i < N; i++)
  {
    float x0,y0;
    x0 = random(0,width/2);
    y0 = random(0,height);
    
    fill(random(0,1) < 0.5f ? 0 : 200, 240);
    blob(x0,y0);
  }

  loadPixels();
  for(int j = 0; j < width/2; j++)
  for(int i = 0; i < height; i++)
  {
    pixels[i*width+(width-j-1)] = pixels[i*width+(j)];
  }
  updatePixels();

  t += TWO_PI/200;
  if(t >= TWO_PI)
  {
    t -= TWO_PI;
    seed = millis();
  }
}

public void blob(float x0, float y0)
{
  beginShape();
  for(int i = 0; i <= V; i++)
  {
    float r = height*(R0 + R1*(-0.5f+noise(ns*i,nst*t)));

    float x,y;
    x = x0 + r*cos(PI/2+TWO_PI*i/V);
    y = y0 + r*sin(PI/2+TWO_PI*i/V);

    x = min(width/2,x);

    curveVertex(x,y);
  }
  endShape(); 
}

public void keyPressed()
{

  if(cp5.isVisible())
    cp5.hide();
  else
    cp5.show();
}

public void initGUI()
{
  cp5 = new ControlP5(this);
  cp5.hide();

  cp5.addSlider("Blobs")
  .setValue(20)
  .setRange(0,50)
  .setPosition(0,0)
  .setSize(120,20);

  cp5.addSlider("Vertices")
  .setValue(500)
  .setRange(0,1000)
  .setPosition(0,21)
  .setSize(120,20);

  cp5.addSlider("R0")
  .setValue(0.25f)
  .setRange(0,1)
  .setPosition(0,42)
  .setSize(120,20);

  cp5.addSlider("R1")
  .setValue(0.25f)
  .setRange(0,1)
  .setPosition(0,63)
  .setSize(120,20);

  cp5.addSlider("Noise_Scale")
  .setValue(0.015f)
  .setRange(0,0.1f)
  .setPosition(0,84)
  .setSize(120,20);

  cp5.addSlider("Time_Scale")
  .setValue(0.5f)
  .setRange(0,2)
  .setPosition(0,105)
  .setSize(120,20);
}

public void Blobs(int x)
{
  N = x;
}

public void Vertices(int x)
{
  V = x;
}

public void R0(float x)
{
  R0 = x;
}

public void R1(float x)
{
  R1 = x;
}

public void Noise_Scale(float x)
{
  ns = x;
}

public void Time_Scale(float x)
{
  nst = x;
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "rorschach" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
