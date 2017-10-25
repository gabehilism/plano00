//import processing.sound.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
//import ddf.minim.effects.*;
//import ddf.minim.signals.*;
//import ddf.minim.spi.*;
//import ddf.minim.ugens.*;

//import controlP5.*;

int N_POLIS = 30;
int N_VERTS = 3;
int MAX_VERTS = 100;

Minim minim;
AudioPlayer player;
AudioInput input;
AudioPlayer song;
FFT fft;
BeatDetect beat_detect;

Controls c;
Background bg;
ChromaticAberrationFilter chroma;

float T = 0.0f;
int T_MODE_BEAT = 0B000001;
int T_MODE_CYCLE = 0B000010;
int T_MODE = T_MODE_BEAT;

float T_KICK;
float T_KICK_DECAY = 0.5f;
float T_SNARE;
float T_SNARE_DECAY = 0.75f;
float T_HAT;
float T_HAT_DECAY = 0.95f;
float T_BEAT;
float T_BEAT_DECAY = 0.3f;

float T_PULSE;
float T_PULSE_SPEED = 0.1f;
float T_PULSE_DECAY = 0.99f;
float T_PULSE_MIN = 0.3f;

float T_CYCLE;
int T_MS_FULL_CYCLE = 1000; // ms 
int T_MS_DIV = 5;

void t_updt(int ms) {  
  T_CYCLE = t_ms2t(ms);
  
  T_KICK *= T_KICK_DECAY;
  if (beat_detect.isKick()) {
    T_KICK = 1.0f;
  }
  
  T_SNARE *= T_SNARE_DECAY;
  if (beat_detect.isSnare()) {
    T_SNARE = 1.0f;
  }
  
  T_HAT *= T_HAT_DECAY;
  if (beat_detect.isHat()) {
    T_HAT = 1.0f;
  }
  
  T_PULSE = lerp(T_PULSE, max(T_KICK, T_SNARE), T_PULSE_SPEED);
  
  //T_BEAT *= T_BEAT_DECAY;
  //if (beat_detect.isRange(0,beat_detect.detectSize(), 3)) {
  //  T_BEAT = 1.0f;
  //}
}

void t_debug() {
  String s = "T: " + T + "\n" +
             "T_KICK: " + T_KICK + "\n" +
             "T_CYCLE: " + T_CYCLE + "\n";
             
  text(s, 0, 100);
}

int t_ms() {
  return millis() / T_MS_DIV;
}

float t_ms2t(int ms) {
  return t_ms2t(ms, T_MS_FULL_CYCLE);
}

float t_ms2t(int ms, int fms) {
  return (float(ms) % fms)/fms;
}

int t_t2ms(float t) {
  return int((t % 1.0f) * T_MS_FULL_CYCLE);
}

// zzz
interface IRandomizable {
  void rng();
  IRandomizable[] get_rng_children();
}

void setup() {
  size(1280, 768, P3D);
  
  minim = new Minim(this);
  input = minim.getLineIn(Minim.STEREO, 2048);
  song = minim.loadFile("set-kika-master-2h.mp3", 2048);
  song.play();
  
  //fft = new FFT(input.bufferSize(), input.sampleRate());
  beat_detect = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat_detect.detectMode(BeatDetect.FREQ_ENERGY);
  beat_detect.setSensitivity(2);
  
  PolyTunnel[] tunnels = {
    
  };
  c = new Controls(tunnels);
  
  layers.add(new Background());
  layers.add(new PolyTunnel(N_POLIS, 50, new EqEmpty(), new Eq00()));
  layers.add(new ChromaticAberrationFilter(new Eq02(), 20));
  
  print(T_MODE_BEAT & T_MODE);
  print("\n");
}

void keyPressed() {
  c.keyPressed();
}

void draw() {
  t_updt(millis());
  
  beat_detect.detect(song.mix);
  
  background(0);
  for (ILayer l : layers) {
    l.draw();
  }
  
  c.updt();
  
  t_debug();
}