import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import controlP5.*;

Minim minim;
AudioPlayer player;
AudioInput input;
FFT fft;

ControlP5 cp5;
ColorPicker colorpicker;

int N = 20;
int M = 50;

boolean cycle_color = false;
float offset;
float radius;
float inner_radius;
float nsi;
float nsj;
float nst;

float t = 0;

void setup()
{
  size(displayWidth,displayHeight);
  colorMode(HSB);
 
  minim = new Minim(this);
  input = minim.getLineIn();
  
  fft = new FFT(input.bufferSize(), input.sampleRate());

  initGUI();
}

void draw()
{
  background(0);
  stroke(255);
  
  pushMatrix();
    translate(width/2,height/2);
    
    fft.forward(input.mix);
    
    noFill();
    if(cycle_color)
    {
      colorMode(HSB);
      stroke(color(255*0.5*(1+cos(0.05*t)),150,150));
      colorMode(RGB);
    }
    else
    {
      stroke(colorpicker.getColorValue());
    }
    
    for(int i = 0; i < N; i++)
    {
      float fi = fft.getBand((i)*fft.specSize()/N);

      float r = inner_radius*height + radius*(N-i)*height/N;
      
      beginShape();
      for(int j = 0; j <= M+2; j++)
      {      
        float d1 = 0.1*height*max(-1*fi, 1.5*(-0.5 + noise(nsi*float(i)/N + nst*t, nsj*cos(0.45*PI + 0.1*PI*j/(M-1)))));
        float d2 = 0.02*height*noise(nsi*(float(i)/N), nsj*cos(0.45*PI + 0.1*PI*j/(M-1)) );
        
        float x,y;
        x = (r+d1+d2)*cos(float(j)*TWO_PI/M + offset*TWO_PI*float(i)/N);
        y = (r+d1+d2)*sin(float(j)*TWO_PI/M + offset*TWO_PI*float(i)/N);
        curveVertex(x,y);
      }
      endShape();
    }
  popMatrix();

  t += 0.1;
}

void keyPressed()
{
  if(cp5.isVisible())
    cp5.hide();
  else
    cp5.show();
}

void initGUI()
{
  cp5 = new ControlP5(this);
  cp5.hide();

  colorpicker = new ColorPicker(cp5, "hacktastic");
  colorpicker
  .setPosition(width-256,0)
  .setColorValue(color(255,150));

  cp5.addButton("Cycle_Color")
  .setValue(0)
  .setPosition(0,0)
  .setSize(120,20)
  ;

  cp5.addSlider("Offset")
  .setValue(0.1)
  .setRange(0,1)
  .setPosition(0,21)
  .setSize(120,20);

  cp5.addSlider("Radius")
  .setValue(0.2)
  .setRange(0,1)
  .setPosition(0,42)
  .setSize(120,20);

  cp5.addSlider("Inner_Radius")
  .setValue(0.2)
  .setRange(0,1)
  .setPosition(0,63)
  .setSize(120,20);

  cp5.addSlider("Radial_Noise_Scale")
  .setValue(1)
  .setRange(0,5)
  .setPosition(0,84)
  .setSize(120,20);

  cp5.addSlider("Angular_Noise_Scale")
  .setValue(100)
  .setRange(0,1000)
  .setPosition(0,105)
  .setSize(120,20);

  cp5.addSlider("Time_Scale")
  .setValue(0.1)
  .setRange(0,1)
  .setPosition(0,126)
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

public void Radial_Noise_Scale(float x)
{
  nsi = x;
}

public void Angular_Noise_Scale(float x)
{
  nsj = x;
}

public void Time_Scale(float x)
{
  nst = x;
}
